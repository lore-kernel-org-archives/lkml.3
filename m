Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966109Ab3HHTnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:43:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40091 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965983Ab3HHTnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:43:18 -0400
Message-ID: <1375990998.2424.168.camel@joe-AO722>
Subject: Re: [PATCH] convert comma to semicolon
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 12:43:18 -0700
In-Reply-To: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1375990372-19033-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 21:32 +0200, Julia Lawall wrote:
> These patches result from the following semantic patch
> (http://coccinelle.lip6.fr/), which checks for expression statements
> separated by , rather than by ;.  The rule is quite conservative in that it
> only finds cases where this pattern appears after a statement that ends
> with ;, to ensure that the expression statements do not form an if branch
> or loop body.  Iteration is used to treat arbitrary sequences of commas.

Nice.

Maybe there also some cases where a block close brace
is followed by a statement , then statement ;

Like from fs/reiserfs/fix_node.c

   231          if ((unsigned int)cur_free >=
   232              (vn->vn_size -
   233               ((vi->vi_type & VI_TYPE_LEFT_MERGEABLE) ? IH_SIZE : 0))) {
   234                  /* all contents of S[0] fits into L[0] */
   235  
   236                  RFALSE(vn->vn_mode == M_INSERT || vn->vn_mode == M_PASTE,
   237                         "vs-8055: invalid mode or balance condition failed");
   238  
   239                  tb->lnum[0] = vn->vn_nr_item;
   240                  tb->lbytes = -1;
   241                  return;
   242          }
   243  
   244          d_size = 0, ih_size = IH_SIZE;


