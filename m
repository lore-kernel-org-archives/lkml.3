Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3EITPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:15:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41502 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3EITPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:15:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Date: Thu, 09 May 2013 21:24:12 +0200
Message-ID: <2958841.JugbRneiDu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <A961433CDFF2F640A2866803152E61F95177AFA9@G4W3219.americas.hpqcorp.net>
References: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net> <2598827.AVAqMcfGuF@vostro.rjw.lan> <A961433CDFF2F640A2866803152E61F95177AFA9@G4W3219.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 09, 2013 07:10:36 PM Ortiz, Lance E wrote:
> Rafael,  
> 
> Thanks for your feedback.
> 
> > The way the changes are described here isn't particularly clear to me.
> 
> I will try to make it a little more clear.

Cool, thanks!

> > Also, since aer_recover_work_func() is going to be the only existing
> > caller of
> > cper_print_aer() after this change, as far as I can say, and it doesn't
> > use the
> > function's first argument, that argument should be dropped entirely.
> 
> The truth is, the function cper_print_aer() really needs to be re-written so
> it is consistent with aer_print_error() in how it outputs information.
> Right now, the output is formatted very differently.  I was planning on doing
> that at a later date, but fix the warning now.  I might add a TODO comment in
> the code for this.

Yes, I think that would be OK, depending on the amount of changes actually
needed to rework it (if that's not too much, I'd just go straight for the
rework, honestly).

> The reason I did not remove the argument in cper_print_aer() is because
> 'prefix' is used in the call to cper_print_bits(), and I passed through an
> empty string to make sure that function worked correctly.  I can try to clean
> it up.

Please do.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
