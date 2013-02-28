Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3B1Qct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:32:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37156 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab3B1Qcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:32:48 -0500
Date: Thu, 28 Feb 2013 17:32:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130228163239.GE9767@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg KH <gregkh@linuxfoundation.org>, mingo@redhat.com,
	tglx@linutronix.de, xen-devel@lists.xen.org,
	linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
	kraman@redhat.com, jwboyer@redhat.com
References: <512E8B41.8000504@zytor.com>
 <20130227230009.GA32465@kroah.com>
 <512E91B7.6060102@zytor.com>
 <20130228142910.GA32354@phenom.dumpdata.com>
 <20130228153846.GA9782@pd.tnic>
 <512F7D88.4090703@zytor.com>
 <20130228161057.GC9767@pd.tnic>
 <512F83C4.6080904@oracle.com>
 <20130228162227.GD9767@pd.tnic>
 <512F856B.5090801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512F856B.5090801@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:27:23AM -0500, Boris Ostrovsky wrote:
> What was the suggestion exactly? I don't remember seeing that message.

Use the paravirt patching facility to replace arch_flush_lazy_mmu_mode()
with a nop when running on baremetal. I.e., the whole functionality
around apply_paravirt() et al.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
