Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428Ab3DHL54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:57:56 -0400
Received: from ozlabs.org ([203.10.76.45]:38217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935183Ab3DHL5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:57:55 -0400
Date: Mon, 8 Apr 2013 21:57:50 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@infradead.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [RFC/PATCH] perf: Expand definition of sysfs format attribute
Message-ID: <20130408115749.GB17849@concordia>
References: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
 <1365411915.2609.143.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365411915.2609.143.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:05:15AM +0200, Peter Zijlstra wrote:
> On Mon, 2013-03-04 at 15:21 +1100, Michael Ellerman wrote:
> > Make it explicit that the format attributes may define overlapping bit
> > ranges. Unfortunately this was left unspecified originally, and all the
> > examples show non-overlapping ranges. I don't believe this is an ABI
> > change, as we are defining something that was previously undefined, but
> > others may disagree.
> > 
> > The POWER8 PMU would like to define overlapping ranges, as bit ranges in
> > the event code have different meanings for certain events. It will also
> > allow us to define an overarching "event" field, that encompasses all
> > others.
> > 
> > As far as I can see perf is comfortable with this change, however I am
> > not sure if there are any other users of the interface.
> > 
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-event_source-devices-format |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> > index 079afc7..77f47ff 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> > +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> > @@ -9,6 +9,12 @@ Description:
> >  		we want to export, so that userspace can deal with sane
> >  		name/value pairs.
> >  
> > +		Userspace must be prepared for the possibility that attributes
> > +		define overlapping bit ranges. For example:
> > +			attr1 = 'config:0-23'
> > +			attr2 = 'config:0-7'
> > +			attr3 = 'config:12-35'
> > +
> >  		Example: 'config1:1,6-10,44'
> >  		Defines contents of attribute that occupies bits 1,6-10,44 of
> >  		perf_event_attr::config1.
> 
> ISTR discussing this with Jiri at some point.. I think we ended up with
> being fine with overlapping ranges but having perf issue a warning (not
> an error) when attributes of a single event have overlap.

OK great.

> I'm not sure the latter was ever implemented in the userspace side.

Yeah not that I can see with a quick look. It's fairly advanced usage
IMHO so a warning would be nice, but not essential.

cheers
