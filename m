Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3CMNrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:47:03 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36694 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab3CMNrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:47:00 -0400
Message-ID: <51408349.8080800@hitachi.com>
Date: Wed, 13 Mar 2013 22:46:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522> <CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com> <514023AA.4070004@hitachi.com> <847glb8m4i.fsf@sauna.l.org>
In-Reply-To: <847glb8m4i.fsf@sauna.l.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/13 22:28), Timo Juhani Lindfors wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>> OK, then I'll update it to just use __always_inline.
> 
> I get a similar case of infinite recursion if I try to kprobe
> "inat_get_opcode_attribute":

Oops, right! And this is caused by below callchain
set_current_kprobes->is_IF_modifier->skip_prefixes
->inat_get_opcode_attribute
However, this looks very wired that the copied instruction
(ainsn->insn) is analyzed at every probe hit.
I think we should add a bit flag indicating IF modifier
to the ainsn.

Thank you for reporting!!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


