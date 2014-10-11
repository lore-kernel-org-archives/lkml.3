Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaJKUAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaJKUAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:00:37 -0400
From: Paul Moore <pmoore@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, serge@hallyn.com, keescook@chromium.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only multicast log socket
Date: Sat, 11 Oct 2014 16:00:30 -0400
Message-ID: <2723550.rc9Q06SjKl@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20141011114206.44963cb3@ivy-bridge>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com> <3117997.iSq2b2nm2S@sifl> <20141011114206.44963cb3@ivy-bridge>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 11, 2014 11:42:06 AM Steve Grubb wrote:
> On Tue, 07 Oct 2014 18:06:51 -0400
> 
> Paul Moore <pmoore@redhat.com> wrote:
> > On Tuesday, October 07, 2014 03:39:51 PM Richard Guy Briggs wrote:
> > > I also thought of moving audit_log_task() from auditsc.c to audit.c
> > > and using that.  For that matter, both audit_log_task() and
> > > audit_log_task_info() could use audit_log_session_info(), but they
> > > are in slightly different order of keywords which will upset
> > > sgrubb's parser.
> > 
> > A bit of an aside from the patch, but in my opinion the parser should
> > be made a bit more robust so that it can handle fields in any
> > particular order.  I agree that having fields in a "canonical
> > ordering" is helpful, both for tools and people, but the tools
> > shouldn't require it in my opinion.
> > 
> > Steve, why exactly can't the userspace parser handle fields in any
> > order?  How difficult would it be to fix?
> 
> The issue is that people that really use audit, really get vast
> quanities of logs. The tools expect things in a specific order so that
> it can pick things out of events as quickly as possible. IOW, it
> knows when it can discard the line because its grabbed everything it
> needs. A casual audit user would never see this. I'm really optimizing
> for the people whose use ausearch and it takes 10 minutes to run.

I understand you are catering to the "power user" here, but I don't see that 
as an excuse for not being able to parse well formed name/value audit record 
string if the order isn't exactly what you expect.  I believe this will only 
become more and more of a problem as things move forward.  I think this is 
something we need to fix soon.

Steve, would you be willing to fix the audit userspace parser so it can handle 
fields in an arbitrary order?  If not, would you be willing to accept patches 
for the userspace that would accomplish this?

-- 
paul moore
security and virtualization @ redhat

