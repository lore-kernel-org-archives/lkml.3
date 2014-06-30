Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaF3Wgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:36:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:28227 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751277AbaF3Wgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:36:41 -0400
Date: Mon, 30 Jun 2014 18:36:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@akamai.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 0/3] static keys: fix test/set races
Message-ID: <20140630183639.0e6161ee@gandalf.local.home>
In-Reply-To: <53B1DA16.5060208@akamai.com>
References: <cover.1372457176.git.jbaron@akamai.com>
	<20140623222802.4900881c@gandalf.local.home>
	<53B1DA16.5060208@akamai.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 17:43:50 -0400
Jason Baron <jbaron@akamai.com> wrote:

> Hi Steve,
> 
> I took a closer look at this, and I'm thinking now that its simpler to
> just take the &inode->i_mutex in sched_feat_write(), surrounding the
> test/set jump_label call. It should be about 3 lines :)

Smaller patches are always nice.

> 
> I started re-working this with the patches in this series and it just
> seemed like a lot of code for only 1 current use-case. (The udp case
> doesn't appear to disable the branch and thus is not racy.)
> 
> So I've swung back to what Ingo originally said - I can test/post the
> suggested 3-line patch, unless there are other thoughts...

Well, the final decision lies with Peter and Ingo. I only noticed it
while cleaning out my inbox and didn't want it to be forgotten.

-- Steve

