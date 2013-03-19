Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3CSPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:50:33 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62849 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3CSPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130319023440.GA12425@aaronlu.sh.intel.com>
References: <20130319023440.GA12425@aaronlu.sh.intel.com>
Date: Tue, 19 Mar 2013 08:50:30 -0700
Message-ID: <CAA25o9RJJ5Rkti9_fTJz2ieaHvrtSp5mE_2LTW_t16_cf_TNcg@mail.gmail.com>
Subject: Re: [tpmdd-devel] tpm_tis driver failed to suspend, error -62
From: Luigi Semenzato <semenzato@google.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Peter <peterasplund@gentoo.se>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error 62 is ETIME.  The driver is timing out during a tpm_send,
possibly trying to send the Tpm_SaveState command.

It may be that you cannot talk to the TPM at all.  Have you tried
sending messages to the TPM before suspending?

Are there any other tpm entries in the syslog?  Like at boot?

What model TPM is it?


On Mon, Mar 18, 2013 at 7:34 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> Hi Rajiv,
>
> Not sure if I should send this to you, please kindly forward it to the
> appropriate person if not, thanks.
>
> Peter has encountered a problem during suspend, the tpm_tis driver's
> suspend callback will fail, the relevant message is:
>
> [  192.281757] PM: Syncing filesystems ... done.
> [  192.692479] Freezing user space processes ... (elapsed 0.01 seconds)
> done.
> [  192.708159] Freezing remaining freezable tasks ... (elapsed 0.01
> seconds)
> done.
> [  192.724151] Suspending console(s) (use no_console_suspend to debug)
> [  192.724612] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [  192.724785] sd 2:0:0:0: [sda] Stopping disk
> [  197.512047] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
> [  197.512055] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
> [  197.512057] PM: Device 00:08 failed to suspend: error -62
> [  197.512058] PM: Some devices failed to suspend
>
> And the problem has been there since v2.6.32(shipped in ubuntu 10.04),
> and the latest upstream tree(v3.9-rcx) also has this problem. The bug
> link is here:
> https://bugzilla.kernel.org/show_bug.cgi?id=45761
>
> Please feel free to ask for more information, thanks.
>
> -Aaron
>
>
> ------------------------------------------------------------------------------
> Everyone hates slow websites. So do we.
> Make your web apps faster with AppDynamics
> Download AppDynamics Lite for free today:
> http://p.sf.net/sfu/appdyn_d2d_mar
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
