Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbaF3Ujn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:39:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaF3Ujl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:39:41 -0400
Date: Mon, 30 Jun 2014 13:39:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [RFC 1/1] proc: constify seq_operations
Message-Id: <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
In-Reply-To: <1404154997-15490-1-git-send-email-fabf@skynet.be>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
> are only called in proc_id_map_open with seq_open as
> const struct seq_operations so we can constify the 3 structures and update
> proc_id_map_open prototype.

There are an absolutely enormous number of places where we could
constify things.  For sheer sanity's sake I'm not inclined to churn the
code in this way unless a patch provides some sort of runtime benefit. 
And this particular patch doesn't appear to change the generated code
at all.


