Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaLAWhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:37:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaLAWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:37:12 -0500
Date: Mon, 1 Dec 2014 23:37:08 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com, pbonzini@redhat.com,
        gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141201223708.GF4730@pd.tnic>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
 <20141201220057.GC4730@pd.tnic>
 <547CEC5C.9070201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <547CEC5C.9070201@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:31:56PM -0500, Boris Ostrovsky wrote:
> I think so. The problem we have now is __pa() macro that we only use
> on 32-bit. I'll queue this for overnight tests to make sure and if it
> indeed works then 3.19 should be fine.

Cool, thanks.

I'd still take your patch for 3.19 though because I'm fixing the 32-bit
reloading path properly and will remove the ifdef afterwards.

And even then, I'd like to prevent loading the module on a paravirt
guest if it is totally unneeded there.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
