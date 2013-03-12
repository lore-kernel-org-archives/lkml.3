Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab3CLVxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:53:17 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:61337 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130312133148.106946def5edb288aafdfb51@linux-foundation.org>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1363049291-946-2-git-send-email-lucas.demarchi@profusion.mobi> <20130312133148.106946def5edb288aafdfb51@linux-foundation.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 12 Mar 2013 18:52:54 -0300
Message-ID: <CAMOw1v7XHryg6pBm7bGCyFqW0WGzi67kbOEpb8TpztFDhUhezQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] usermodehelper: Export _exec() and _setup() functions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, lucas.de.marchi@gmail.com,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 5:31 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Mar 2013 21:48:06 -0300 Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:
>
>> call_usermodehelper_setup() + call_usermodehelper_exec() need to be
>> called instead of call_usermodehelper_fns() when the cleanup function
>> needs to be called even when an ENOMEM error occurs. In this case using
>> call_usermodehelper_fns() the user can't distinguish if the cleanup
>> function was called or not.
>
> call_usermodehelper_exec() was exported to modules but
> call_usermodehelper_setup() was not?
>

That was a mistake. We need both functions exported. Should I send and
updated patch or a fixup?


Lucas De Marchi
