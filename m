Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab3CHRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:12:55 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:49998 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab3CHRMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:12:52 -0500
Message-ID: <1362762762.4219.37.camel@thor.lan>
Subject: Re: [PATCH v4 25/32] tty: Add read-recursive, writer-prioritized rw
 semaphore
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 08 Mar 2013 12:12:42 -0500
In-Reply-To: <1361390599-15195-26-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1361390599-15195-26-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 15:03 -0500, Peter Hurley wrote:
> The semantics of a rw semaphore are almost ideally suited
> for tty line discipline lifetime management;  multiple active
> threads obtain "references" (read locks) while performing i/o
> to prevent the loss or change of the current line discipline
> (write lock).
> 
> Unfortunately, the existing rw_semaphore is ill-suited in other
> ways;
> 1) obtaining a "reference" can be recursive, ie., a reference holder
>    may attempt to obtain another "reference". Recursive read locks
>    are not supported by rwsem.

Hi Greg,

I just finished auditing all the recursive usage of the tty/ldisc layer
and I can make this lock non-recursive.

Please hold off applying this and I'll send you a v5 series in a couple
of days, ok?

Regards,
Peter Hurley


