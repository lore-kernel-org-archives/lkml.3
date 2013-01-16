Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3APBQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:16:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:62232 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab3APBQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:16:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="244387787"
Message-ID: <50F5FF71.5080403@linux.intel.com>
Date: Tue, 15 Jan 2013 17:16:33 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Ondrej Zary <linux@rainbow-software.org>, dmitry.torokhov@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: your patch "x86, 8042: Enable A20 using KBC to fix S3 resume
 on some MSI laptops"
References: <50F3CAFD02000078000B52BE@nat28.tlf.novell.com> <201301140929.38462.linux@rainbow-software.org> <50F3D1F702000078000B52FB@nat28.tlf.novell.com> <201301140954.43795.linux@rainbow-software.org> <50F3D7A302000078000B531D@nat28.tlf.novell.com>
In-Reply-To: <50F3D7A302000078000B531D@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 01:02 AM, Jan Beulich wrote:
>>
>> What's "properly"? Doing extra 8042 detection somewhere else does not look 
>> right.
> 
> Why?
> 

Because it is time consuming, and threatens to step on things.

Enabling A20 is one thing, but this is something else... if we have the
KBC, we want to enable A20 *again* just in case.  Having the i8042 code
in one place makes sense to me.  This doesn't have to be done early.
The affected systems are *extremely* unlikely to ever be run without the
i8042 driver loaded, and the failure mode benign enough (if you actually
want to run a specific laptop without the keyboard driver, you can't
suspend it) that there really is no point to have yet another driver for
the same hardware that would stomp on each other.

	-hpa

