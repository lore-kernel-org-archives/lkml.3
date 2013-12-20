Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3LTPtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:49:13 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:55621 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3LTPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:49:11 -0500
Subject: Re: [PATCH 2/2] GenWQE: Replace dynamic_hex_dump with
 print_hex_dump_debug
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
In-Reply-To: <20131220153309.GA21797@kroah.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
	 <1387553171-31469-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131220153309.GA21797@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 20 Dec 2013 16:49:03 +0100
Message-ID: <1387554543.1847.22.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122015-3548-0000-0000-0000078D4FFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Freitag, den 20.12.2013, 07:33 -0800 schrieb Greg KH:
> On Fri, Dec 20, 2013 at 04:26:11PM +0100, Frank Haverkamp wrote:
> > As requested by Greg, replacing the hexdump function from dynamic_debug.h
> > with one defined in printk.h. I hope I picked the right one.
> 
> No, just use the "%*ph" modifier for printk.
> 
> So, you can do it all on just one line:
>   	scnprintf(prefix, sizeof(prefix), "%s %s: %*ph\n",
>   		  GENWQE_DEVNAME, pci_name(pci_dev), size, buff);

Oh, I did not know that such a feature exists. The buffer I like to dump
is 256 bytes large. Looking in to Documentation/printk-formats.txt it
says:

Raw buffer as a hex string:
        %*ph    00 01 02  ...  3f
        %*phC   00:01:02: ... :3f
        %*phD   00-01-02- ... -3f
        %*phN   000102 ... 3f

        For printing a small buffers (up to 64 bytes long) as a hex
string with
        certain separator. For the larger buffers consider to use
        print_hex_dump().

So is my choice still not ok, considering the data size I like to dump?

> And even then, do you really need this genwqe_hexdump() function at all
> anymore?  What is it used for?

We were using this feature to dump work-requests before and after they
had been sent to the card. This was very helpful when there was a
problem with the card executing one of those requests. Now since the
card is really running stable, you  could argue that we do not need it
anymore. So if you really, really insist, I will remove the feature else
I would like to keep it.

> greg k-h

Regards

Frank

