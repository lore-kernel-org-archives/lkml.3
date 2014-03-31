Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaCaMZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:25:06 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60535 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbaCaMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:25:00 -0400
Message-ID: <1396268697.2110.15.camel@x220>
Subject: Re: CONFIG_PREEMPT_COUNT
From: Paul Bolle <pebolle@tiscali.nl>
To: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>
Date: Mon, 31 Mar 2014 14:24:57 +0200
In-Reply-To: <AD975D71AAD7784D8D1265DF6444C2FD0132AD51@storexdag03.amd.com>
References: <AD975D71AAD7784D8D1265DF6444C2FD0132AD51@storexdag03.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2014 12:24:58.0566 (UTC) FILETIME=[3B226660:01CF4CDC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey,

On Mon, 2014-03-31 at 10:38 +0000, Skidanov, Alexey wrote:
> What is the purpose of CONFIG_PREEMPT_COUNT define and how I can
> define it?

CONFIG_PREEMPT_COUNT is a Kconfig macro, ie it's (in short) to be
defined as a result one of the "*config" make targets. And doing
    git grep -nw PREEMPT_COUNT

gives
    kernel/Kconfig.preempt:38:      select PREEMPT_COUNT
    kernel/Kconfig.preempt:57:config PREEMPT_COUNT
    lib/Kconfig.debug:964:  select PREEMPT_COUNT

And looking at those hits it seems PREEMPT_COUNT will be set, and
therefore CONFIG_PREEMPT_COUNT defined, if either PREEMPT or
DEBUG_ATOMIC_SLEEP are set in a .config.

(I'm not familiar with PREEMPT_COUNT. I think I never used it.)

Hope this helps,


Paul Bolle

