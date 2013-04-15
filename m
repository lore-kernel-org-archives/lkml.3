Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3DOIvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:51:31 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:52384 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3DOIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:51:30 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
Date: Mon, 15 Apr 2013 10:51:29 +0200
Message-ID: <227672966.BSYPVcyNU7@harkonnen>
User-Agent: KMail/4.10.1 (Linux/3.8.5-201.fc18.x86_64; KDE/4.10.1; x86_64; ; )
In-Reply-To: <51691053.7060707@metafoo.de>
References: <3798489.yISokZugC2@harkonnen> <2849474.HO2K6X9Bdi@harkonnen> <51691053.7060707@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,
 
> Considering that there seems to be a common pattern here where the caller
> only wants to know if the device exists, but is not really interested in the
> device itself, how about adding a helper function for this?

It was my first thought when I opened this thread. But now I'm convinced that 
device_for_each_child() is the best choice (maybe I'm wrong).

device_for_each_child() allow you to perform an operation of each child of a 
device: look for a specific child, do something on every children, retrieve a 
specific group of children, etc.

I think that an helper for this case will be a perfect duplication of 
device_for_each_child() with a different name and comment (borrowed from 
device_find_child()). Maybe, a macro to assign a different name to this 
function:

/*
 * [...]
 * The callback should return 0 if the device doesn't match and non-zero
 * if it does
 * [...]
 */
#define device_has_child(parent, data, match) device_for_each_child(parent, 
data, match)

But, is it useful? It can be a suggestion to developers to prefer 
device_for_each_child() instead of device_find_child() when (s)he is 
interested only about the child existence. So, (s)he does not need to 
put_device(). But I think that is not a strong argumentation, and later in 
time someone will propose his own special use of device_for_each_child().

I think that device_for_each_child() is generic enough to cover this problem.

-- 
Federico Vaga
