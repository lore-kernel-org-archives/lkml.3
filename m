Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3GAQuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:50:06 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48620 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3GAQuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:50:04 -0400
Date: Mon, 01 Jul 2013 11:49:58 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] proc: Document that /proc/<pid>/task/<tid>/children
 really is per-thread
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto@amacapital.net>
	(from luto@amacapital.net on Wed Jun 26 16:05:01 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372697398.5019.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:05:01 PM, Andy Lutomirski wrote:
> I was surprised to discover that a process can have a parent that  
> isn't
> a thread group leader.  (The usual ppid interfaces hide this, but the
> children list exposes it.)
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  Documentation/filesystems/proc.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.txt  
> b/Documentation/filesystems/proc.txt
> index fd8d0d5..205796a 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1623,6 +1623,12 @@ This file provides a fast way to retrieve  
> first level children pids
>  of a task pointed by <pid>/<tid> pair. The format is a space  
> separated
>  stream of pids.
> 
> +This really is a per-thread list.  If a process's parent is a thread,
> +then that process will appear in that thread's children list.  (This
> +means that, for any pid, /proc/pid/task/*/children are disjoint  
> lists.)
> +This may be surprising, as /proc/pid/status's PPid field is parent's
> +tgid as opposed to the parent's tid.

I've read this twice and still don't quite understand what it's saying.  
(Possibly I need more than 3 hours of sleep.)

It sounds like you're saying a thread can fork() and exec() and this  
makes proc look weird, because the ppid pooints to the thread group  
leader and not the thread, but the proc info listing us as a child  
belongs to the thread?

Is this a bug that should be fixed rather than documented? (Showing the  
right ppid for this corner case?)

Rob