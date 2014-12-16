Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaLPQrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:47:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaLPQri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:47:38 -0500
Message-ID: <54906212.2010102@zytor.com>
Date: Tue, 16 Dec 2014 08:47:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, akataria@vmware.com,
        jongman.heo@samsung.com
Subject: Re: [PATCH] x86: don't rely on VMWare emulating PAT MSR correctly
References: <1418723914-9736-1-git-send-email-jgross@suse.com>
In-Reply-To: <1418723914-9736-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 01:58 AM, Juergen Gross wrote:
> VMWare seems not to emulate the PAT MSR correctly: reaeding
> MSR_IA32_CR_PAT returns 0 even after writing another value to it.
> 
> Detect this bug and don't use the read value if it is 0.
> 
> Commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 ("x86: Enable PAT to
> use cache mode translation tables") triggers this VMWare bug when the
> kernel is booted as a VMWare guest.
> 
> Reported-by: Jongman Heo <jongman.heo@samsung.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Jongman Heo <jongman.heo@samsung.com>

I presume cachability control is irrelevant for a VMware guest?  I'm
wondering if it would be better to just plain ignore the failure rather
than disabling PAT.

	-hpa


