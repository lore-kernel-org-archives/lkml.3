Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3COVTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:19:37 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:59181 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3COVTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:19:35 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        "Satoru Moriya (smoriya@redhat.com)" <smoriya@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Paul E. McKenney (paulmck@us.ibm.com)" <paulmck@us.ibm.com>
Subject: RE: [PATCH v11 1/3] tracing: Add DEFINE_EVENT_FN() macro
Thread-Topic: [PATCH v11 1/3] tracing: Add DEFINE_EVENT_FN() macro
Thread-Index: Ac4hvKsIqtw+PLhySdSgBEALskgvmQAJlV2AAAgwcAA=
Date: Fri, 15 Mar 2013 21:17:08 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6A12A@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6A03D@USINDEM103.corp.hds.com>
 <1363381809.25967.64.camel@gandalf.local.home>
In-Reply-To: <1363381809.25967.64.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-03-15_08:2013-03-15,2013-03-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=inbound_policy_notspam policy=inbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1303150165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You still need to add:
> 
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Otherwise you get the authorship of this patch.

My apologies.  I resend my patch 1/3 by adding it shortly.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Friday, March 15, 2013 5:10 PM
> To: Seiji Aguchi
> Cc: H. Peter Anvin (hpa@zytor.com); x86@kernel.org; linux-kernel@vger.kernel.org; Thomas Gleixner (tglx@linutronix.de);
> 'mingo@elte.hu' (mingo@elte.hu); Borislav Petkov (bp@alien8.de); Satoru Moriya (smoriya@redhat.com); dle-
> develop@lists.sourceforge.net; linux-edac@vger.kernel.org; Luck, Tony (tony.luck@intel.com); Paul E. McKenney
> (paulmck@us.ibm.com)
> Subject: Re: [PATCH v11 1/3] tracing: Add DEFINE_EVENT_FN() macro
> 
> You still need to add:
> 
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Otherwise you get the authorship of this patch.
> 
> -- Steve
> 
> 
> On Fri, 2013-03-15 at 20:35 +0000, Seiji Aguchi wrote:
> > Each TRACE_EVENT() adds several helper functions. If two or more trace
> > events share the same structure and print format, they can also share
> > most of these helper functions and save a lot of space from duplicate
> > code. This is why the
> > DECLARE_EVENT_CLASS() and DEFINE_EVENT() were created.
> >
> > Some events require a trigger to be called at registering and
> > unregistering of the event and to do so they use TRACE_EVENT_FN().
> >
> > If multiple events require a trigger, they currently have no choice
> > but to use
> > TRACE_EVENT_FN() as there's no DEFINE_EVENT_FN() available. This
> > unfortunately causes a lot of wasted duplicate code created.
> >
> > By adding a DEFINE_EVENT_FN(), these events can still use a
> > DECLARE_EVENT_CLASS() and then define their own triggers.
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> > ---
> >  include/linux/tracepoint.h   |    2 ++
> >  include/trace/define_trace.h |    5 +++++
> >  include/trace/ftrace.h       |    4 ++++
> >  3 files changed, 11 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 2f322c3..9bf59e5 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -378,6 +378,8 @@ static inline void
> > tracepoint_synchronize_unregister(void)
> >  #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
> >  #define DEFINE_EVENT(template, name, proto, args)		\
> >  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> > +#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)\
> > +	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> >  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> >  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> >  #define DEFINE_EVENT_CONDITION(template, name, proto,		\
> > diff --git a/include/trace/define_trace.h
> > b/include/trace/define_trace.h index 1905ca8..02e1003 100644
> > --- a/include/trace/define_trace.h
> > +++ b/include/trace/define_trace.h
> > @@ -44,6 +44,10 @@
> >  #define DEFINE_EVENT(template, name, proto, args) \
> >  	DEFINE_TRACE(name)
> >
> > +#undef DEFINE_EVENT_FN
> > +#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
> > +	DEFINE_TRACE_FN(name, reg, unreg)
> > +
> >  #undef DEFINE_EVENT_PRINT
> >  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> >  	DEFINE_TRACE(name)
> > @@ -91,6 +95,7 @@
> >  #undef TRACE_EVENT_CONDITION
> >  #undef DECLARE_EVENT_CLASS
> >  #undef DEFINE_EVENT
> > +#undef DEFINE_EVENT_FN
> >  #undef DEFINE_EVENT_PRINT
> >  #undef DEFINE_EVENT_CONDITION
> >  #undef TRACE_HEADER_MULTI_READ
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h index
> > 40dc5e8..7bab676 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -71,6 +71,10 @@
> >  	static struct ftrace_event_call	__used		\
> >  	__attribute__((__aligned__(4))) event_##name
> >
> > +#undef DEFINE_EVENT_FN
> > +#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)	\
> > +	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
> > +
> >  #undef DEFINE_EVENT_PRINT
> >  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> >  	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
> > -- 1.7.1
> >
> 

