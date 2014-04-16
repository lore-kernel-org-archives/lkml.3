Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbaDPNi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:38:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36393 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203AbaDPNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:38:24 -0400
Date: Wed, 16 Apr 2014 14:31:45 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/7] ftrace: Add arm64 support to recordmcount
Message-ID: <20140416133145.GC1001@arm.com>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862048-28758-4-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394862048-28758-4-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 05:40:44AM +0000, AKASHI Takahiro wrote:
> Recordmcount utility under scripts is run, after compiling each object,
> to find out all the locations of calling _mcount() and put them into
> specific seciton named __mcount_loc.
> Then linker collects all such information into a table in the kernel image
> (between __start_mcount_loc and __stop_mcount_loc) for later use by ftrace.
> 
> This patch adds arm64 specific definitions to identify such locations.
> There are two types of implementation, C and Perl. On arm64, only C version
> is used to build the kernel now that CONFIG_HAVE_C_RECORDMCOUNT is on.
> But Perl version is also maintained.
> 
> This patch also contains a workaround just in case where a header file,
> elf.h, on host machine doesn't have definitions of EM_AARCH64 nor
> R_AARCH64_ABS64. Without them, compiling C version of recordmcount will
> fail.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
