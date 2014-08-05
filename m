Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaHEX3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:29:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaHEX3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:29:17 -0400
Date: Tue, 5 Aug 2014 16:29:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 5/7] tty: Deal with nested sleeps
Message-ID: <20140805232916.GC26505@kroah.com>
References: <20140804103025.478913141@infradead.org>
 <20140804103537.628164803@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804103537.628164803@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 12:30:30PM +0200, Peter Zijlstra wrote:
> n_tty_{read,write} are wait loops with sleeps in. Wait loops rely on
> task_struct::state and sleeps do too, since that's the only means of
> actually sleeping. Therefore the nested sleeps destroy the wait loop
> state and the wait loop breaks the sleep functions that assume
> TASK_RUNNING (mutex_lock).
> 
> Fix this by using the new woken_wake_function and wait_woken() stuff,
> which registers wakeups in wait and thereby allows shrinking the
> task_state::state changes to the actual sleep part.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  drivers/tty/n_tty.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
