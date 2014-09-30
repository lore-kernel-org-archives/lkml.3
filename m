Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaI3Lwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:52:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35983 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3Lwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:52:33 -0400
Date: Tue, 30 Sep 2014 13:52:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, tglx@linutronix.de, hpa@zytor.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: detect the threshold at the
 initialization period
Message-ID: <20140930115229.GE4639@pd.tnic>
References: <1411616289-28684-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411616289-28684-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:38:09AM +0800, Chen Yucong wrote:
> ADM64 APM Volume 2 (9.3.2 Error-Reporting Register Banks)documents
> that the size of threshold counter is implementation-dependent, and
> the implementations with less than 16 bits fill the most significant
> unimplemented bits with zeros. So THRESHOLD_MAX should be detected
> at the initialization period rather than a constant.
> 
> On the other hand, Error Counter (ERRCT) is bits 47:32, and accordingly
> MASK_ERR_COUNT_HI should be 0x0000FFFF instead of 0x00000FFF.

All the families currently use 12 bits only, i.e. slice [43:32] so
there's no need for changing the current code. We'll address it when it
is actually needed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
