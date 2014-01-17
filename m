Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaAQURx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:17:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaAQURt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:17:49 -0500
Date: Fri, 17 Jan 2014 12:18:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix NMI window after iret
Message-ID: <20140117201831.GA20561@kroah.com>
References: <1389988362-15260-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389988362-15260-1-git-send-email-rkrcmar@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:52:42PM +0100, Radim Krčmář wrote:
> We should open NMI window right after an iret, but SVM exits before it.
> We wanted to single step using the trap flag and then open it.
> (or we could emulate the iret instead)
> We don't do it since commit 3842d135ff2 (likely), because the iret exit
> handler does not request an event, so NMI window remains closed until
> the next exit.
> 
> Fix this by making KVM_REQ_EVENT request in the iret handler.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  (btw. kvm-unit-tests weren't executed on SVM since Nov 2010, at least)
> 
>  arch/x86/kvm/svm.c | 1 +
>  1 file changed, 1 insertion(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
