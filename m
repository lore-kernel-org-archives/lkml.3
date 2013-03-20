Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3CTV2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:28:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56878 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CTV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <1363791432.12701.8.camel@pasglop>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
 <1363791074-16415-2-git-send-email-grant.likely@secretlab.ca> <1363791432.12701.8.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Mar 2013 21:28:01 +0000
X-Google-Sender-Auth: Suh293YpHGLFMQlcFcvRJwGOwu8
Message-ID: <CACxGe6vw5sevcv=NgeQDhH1QuGgTphia-AnKbSQkVm64tSgNSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] of: Make device nodes kobjects so they show up in sysfs
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 2:57 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2013-03-20 at 14:51 +0000, Grant Likely wrote:
>> Both of the above problems can be worked around by using
>> sysfs_create_bin_file() instead of sysfs_create_file(), but doing so
>> adds an additional 20 to 40 bytes of overhead per property. A device
>> tree has a lot of properties in it. That overhead will very quickly add
>> up. The other option is to create a new custom sysfs attribute type
>> would solve the problem without additional overhead, but at the cost of
>> more complexity in the sysfs support code. However, I'm hopeful that
>> these problems are just imaginary and we can stick with normal sysfs
>> attributes.
>
> Disagreed. It would break stuff, especially the incorrect file size.

I retried with bin files. Turns out I should stop making assumptions
and actually try things. It requires less code, is simpler and pretty
much eliminates the issues listed above. :-)

I'll post a new series with the fixes.

g.
