Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3HEBVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 21:21:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60969 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754100Ab3HEBVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 21:21:41 -0400
Message-ID: <1375665700.3133.19.camel@joe-AO722>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        "'Jiri Kosina'" <trivial@kernel.org>, jaharkes@cs.cmu.edu,
        coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 04 Aug 2013 18:21:40 -0700
In-Reply-To: <51FEF0AC.8040804@asianux.com>
References: <51F76B7D.2090602@asianux.com>
	 <1375187380.2075.111.camel@joe-AO722> <51F86C08.3080805@asianux.com>
	 <51F86E1A.60404@asianux.com> <51F8818C.7030703@gmail.com>
	 <51FEF0AC.8040804@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 08:24 +0800, Chen Gang wrote:
> On 07/31/2013 11:16 AM, Chen Gang F T wrote:
> > On 07/31/2013 09:53 AM, Chen Gang wrote:
> >> On 07/31/2013 09:44 AM, Chen Gang wrote:
> >>> On 07/30/2013 08:29 PM, Joe Perches wrote:
> >>>> On Tue, 2013-07-30 at 15:30 +0800, Chen Gang wrote:
> >>>>> '#else' is useless, need remove.
> >>>>>
> >>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >>>>> ---
> >>>>>  include/linux/coda.h |    1 -
> >>>>>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>>>>
> >>>>> diff --git a/include/linux/coda.h b/include/linux/coda.h
> >>>>> index cff544f..d30209b 100644
> >>>>> --- a/include/linux/cod
> >>>>> +++ b/include/linux/coda.h
> >>>>> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
> >>>>>  
> >>>>>  #if defined(__linux__)
> >>>>>  typedef unsigned long long u_quad_t;
> >>>>> -#else
> >>>>>  #endif
> >>>>>  #include <uapi/linux/coda.h>
> >>>>>  #endif 
> >>>>
> >>>> Why have the #if at all?
> >>>>
> 
> Hmm... if any members have some questions about the fix, commonly it
> means the related fix need additional improvement.
> 
> Is it better to use BUILD_BUG() for the fix ?

Probably not.  __linux__ is predefined by gcc.

Using an #ifdef __linux__ might make some sense in
in include/uapi, but not in include/linux.


