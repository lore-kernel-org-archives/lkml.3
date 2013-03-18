Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3CRNLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:11:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3CRNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:11:29 -0400
Message-ID: <1363612263.22553.12.camel@laptop>
Subject: Re: [PATCH] perf: fix ring_buffer perf_output_space() boundary
 calculation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Date: Mon, 18 Mar 2013 14:11:03 +0100
In-Reply-To: <CABPqkBRGutLBC+mO+F8fH5F-Yoe1NL8e_=yF9boxA28jNLO56g@mail.gmail.com>
References: <20130318124847.GA2491@quad> <1363611569.22553.10.camel@laptop>
	 <CABPqkBRGutLBC+mO+F8fH5F-Yoe1NL8e_=yF9boxA28jNLO56g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 14:03 +0100, Stephane Eranian wrote:
> On Mon, Mar 18, 2013 at 1:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2013-03-18 at 13:48 +0100, Stephane Eranian wrote:
> >>         if (!rb->writable)
> >> -               return true;
> >> +               return false;
> >
> >
> > writable means user writable (VM_WRITE); the difference is that a
> > !VM_WRITE buffer will simply over-write its own tail whereas a VM_WRITE
> > buffer will drop events.
> >
> > So returning true for !VM_WRITE makes sense, there's always space.
> >
> Ok, that was not so clear to me. I think this if() statment deserves a comment.
> I will add that in V2.

Thanks; I suppose renaming the entire ->writable thing might be better
though. Something like ->overwrite or so.

