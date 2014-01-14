Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaANQKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:10:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaANQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:10:45 -0500
Message-ID: <52D56174.9010608@zytor.com>
Date: Tue, 14 Jan 2014 08:10:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
In-Reply-To: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:58 AM, tip-bot for Borislav Petkov wrote:
> Commit-ID:  bad5fa631fca5466401cd4a48e30cc1f1cb6101e
> Gitweb:     http://git.kernel.org/tip/bad5fa631fca5466401cd4a48e30cc1f1cb6101e
> Author:     Borislav Petkov <bp@suse.de>
> AuthorDate: Sun, 1 Dec 2013 18:09:58 +0100
> Committer:  Borislav Petkov <bp@suse.de>
> CommitDate: Mon, 13 Jan 2014 20:00:12 +0100
> 
> x86, microcode: Move to a proper location
> 
> We've grown a bunch of microcode loader files all prefixed with
> "microcode_". They should be under cpu/ because this is strictly
> CPU-related functionality so do that and drop the prefix since they're
> in their own directory now which gives that prefix. :)
> 
> While at it, drop MICROCODE_INTEL_LIB config item and stash the
> functionality under CONFIG_MICROCODE_INTEL as it was its only user.
> 

Quite frankly I would be much happier if we didn't stash so much under
arch/x86/kernel/cpu ... quite frankly it feels like almost *anything*
could go under there.  The microcode code, for example, could go under
its own subtree.

Both kernel and kernel/cpu really could use a house cleaning and
actually separate things out into better categories and avoid needlessly
deep pathnames.

	-hpa


