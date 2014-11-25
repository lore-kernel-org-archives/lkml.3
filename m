Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaKYOOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:14:14 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33917 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaKYOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:14:12 -0500
Date: Tue, 25 Nov 2014 14:14:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141125141400.GG3836@n2100.arm.linux.org.uk>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
 <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
 <20141118140425.GM18842@arm.com>
 <546C58DB.5080204@linaro.org>
 <20141119190601.GM15985@arm.com>
 <546D7860.2010300@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D7860.2010300@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:13:04PM +0900, AKASHI Takahiro wrote:
> On 11/20/2014 04:06 AM, Will Deacon wrote:
> >What does x86 do?
> 
> On x86, syscall(-1) returns -ENOSYS if not traced, and we can change a return
> value if traced.

... which is used for UML (user mode Linux).  UML works by spawning
processes under the host kernel, which run with syscall tracing enabled,
with the UML kernel as the tracer.  The UML kernel tracer receives the
syscall trace event when the child tries to execute a syscall, decodes
the syscall, executes syscall in the UML kernel, and then cancels the
syscall in the host kernel, setting the return code appropriately.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
