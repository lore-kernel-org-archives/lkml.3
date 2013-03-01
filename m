Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3CALCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:02:24 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37714 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3CALCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:02:23 -0500
Message-ID: <51308ABD.2020509@hitachi.com>
Date: Fri, 01 Mar 2013 20:02:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: Re: kprobing "hash_64.constprop.26" crashes the system,
 recursion through get_kprobe?
References: <84ehg2jdny.fsf@sauna.l.org> <20130301053123.GA30500@in.ibm.com> <513041D0.4010209@hitachi.com> <84sj4fik71.fsf@sauna.l.org> <513088E0.4090704@hitachi.com>
In-Reply-To: <513088E0.4090704@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/01 19:54), Masami Hiramatsu wrote:
> Actually, __kprobes is used much more than we need, because that
> is safer (and also, that is used just for marking functions
> related to kprobes).
> 
> Only what functions we need to mark __kprobes is the functions
> called from do_int3, and optimized_callback, until processing
> recursive call (which is done by kprobe_running() and
> reenter_kprobe()).

Ah, I forgot to mention that interrupt/exception/NMI related code too...

Thanks,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


