Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaI3J4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:56:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63746 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaI3J4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:56:42 -0400
Message-ID: <1412070991.16556.12.camel@cyc>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 17:56:31 +0800
In-Reply-To: <20140930072553.GA4639@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian> <20140929120546.GB6495@pd.tnic>
	 <1412037578.21488.11.camel@debian> <20140930072553.GA4639@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 09:25 +0200, Borislav Petkov wrote:
> >                       if (high & MASK_OVERFLOW_HI) {
> >                               rdmsrl(address, m.misc);
> >                               rdmsrl(MSR_IA32_MCx_STATUS(bank),
> m.status);
> > +                             if (m.status & MCI_STATUS_ADDRV)
> >
> +                                     rdmsrl(MSR_IA32_MCx_ADDR(bank),
> m.addr);
> >                               m.bank = K8_MCE_THRESHOLD_BASE
> >                                      + bank * NR_BLOCKS
> >                                      + block;
> >                               mce_log(&m);
> > -                             return;
> > +
> > +                             wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
> 
> No, machine_check_poll will clear it anyway and now you're adding a
> purely useless MSR write here which costs.
I just clear it to avoid that the mce_log() call logs the above
threshold event again in machine_check_poll().
> 
> > +                             goto log_mcheck;
> 
> Why goto? It will hit that machine_check_poll below even without
> it... 
It is just used for scanning other banks for recording other valid 
error information.

thx!
cyc

