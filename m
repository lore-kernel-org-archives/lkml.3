Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3EIULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:11:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3EIULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:11:10 -0400
Date: Thu, 9 May 2013 13:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: audit_tree: resource management: need
 put_tree and goto Err when failure occures
Message-Id: <20130509131108.8a70aa5116ff0e3c250feb8b@linux-foundation.org>
In-Reply-To: <518B9C32.7050408@asianux.com>
References: <517110BA.5070806@asianux.com>
	<20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
	<518B9C32.7050408@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 May 2013 20:53:06 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> get_tree() in audit_add_tree_rule() is needed (my original conclusion is incorrect).

OK..

> But we need let 'rule->tree = NULL;' firstly, so can protect rule itself freed in kill_rules().

I'll believe you ;) I turned this into a proper patch and added your
(missed) Signed-off-by:.

> For me, after 'rule->tree = NULL', all things seems fine !!

Well, what was wrong before?  Is there some user-triggerable
misbehaviour which you observed?  If so, please describe it.

