Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3LKDEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:04:49 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55489 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3LKDEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:04:45 -0500
Message-ID: <52A7D646.2040904@hitachi.com>
Date: Wed, 11 Dec 2013 12:04:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v5 13/18] notifier: Use NOKPROBE_SYMBOL macro in
 notifier
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal> <20131209104748.13397.52431.stgit@kbuild-fedora.novalocal> <52A7D4C0.7060700@hitachi.com>
In-Reply-To: <52A7D4C0.7060700@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 11:58), Masami Hiramatsu wrote:
> (2013/12/09 19:47), Masami Hiramatsu wrote:
>> Use NOKPROBE_SYMBOL macro to protect functions from
>> kprobes instead of __kprobes annotation in notifier.
> 
> Ah, this must just removes __kprobes since we don't use notify_die
> for kprobes anymore...

Oops, NO. kprobes generically still using the exception notifier to handle
GPF in the handler even on x86... For safety, I'd like to keep it as it is
until all dependency is removed.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


