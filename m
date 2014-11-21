Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaKUP1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:27:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199AbaKUP1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:27:52 -0500
Date: Fri, 21 Nov 2014 16:27:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
In-Reply-To: <20141121152103.GB26264@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1411211626110.23174@pobox.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz> <20141121152103.GB26264@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Josh Poimboeuf wrote:

> I think we can use "depends on HAVE_FENTRY" to accomplish this, since 
> CC_USING_FENTRY gets set by the top level kernel Makefile if 
> CONFIG_HAVE_FENTRY is set.

The problem is that HAVE_FENTRY is set automatically on x86_64, no matter 
whether your actual compiler supports it or not.

CC_USING_FENTRY is defined if and only if the actual currently used 
compiler supports it, but that can't be expressed in Kconfig.

-- 
Jiri Kosina
SUSE Labs
