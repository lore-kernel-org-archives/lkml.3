Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659Ab3BNVDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:03:11 -0500
Received: from kanga.kvack.org ([205.233.56.17]:57027 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656Ab3BNVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:03:09 -0500
Date: Thu, 14 Feb 2013 16:03:09 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zab@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WIP v1] aio: experimental use of threads, demonstration of cancel method
Message-ID: <20130214210309.GD25505@kvack.org>
References: <20130213221632.GA25312@kvack.org> <20130214193333.GG22221@lenny.home.zabbo.net> <20130214205328.GB25505@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214205328.GB25505@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 03:53:28PM -0500, Benjamin LaHaise wrote:
> If the kiocb has been cancelled, this code ensures that the helper thread 
> has received the SIGSEGV.  This ensures that the signal can then be flushed 
> by flush_signals().  If the kiocb has not been cancelled, it can no longer 
> be cancelled after the cmpxchg() has executed.

Whoops, SIGSEGV will certainly need special handling.  The cancel code 
should really be using SIGKILL.  I will add that to the list of things 
to fix.

		-ben
-- 
"Thought is the essence of where you are now."
