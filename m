Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3C2TdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:33:16 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41440 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3C2TdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:33:13 -0400
Message-ID: <1364585585.31320.5.camel@thor.lan>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Peter Hurley <peter@hurleysoftware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Date: Fri, 29 Mar 2013 15:33:05 -0400
In-Reply-To: <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	 <20130326192852.GA25899@redhat.com>
	 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	 <20130329161746.GA8391@redhat.com>
	 <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 11:43 -0700, Linus Torvalds wrote:
> I think I foud at least one bug in the MSG_COPY stuff: it leaks the
> "copy" allocation if
> 
>     mode == SEARCH_LESSEQUAL
> 
> but maybe I'm misreading it.

Yes, you're misreading it. copy_msg() returns the 'copy' address when
copying is successful. So this patch double-frees 'copy'.

Andrew has had the patches that fix this for a month but because they're
fairly extensive he didn't want to apply them for 3.9.

Regards,
Peter


