Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaCMBoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaCMBoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:44:03 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
From: Simo Sorce <ssorce@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
In-Reply-To: <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
	 <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
	 <5320CAEC.6030008@amacapital.net>
	 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
	 <1394658983.32465.203.camel@willson.li.ssimo.org>
	 <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
	 <1394673476.32465.215.camel@willson.li.ssimo.org>
	 <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 21:43:58 -0400
Message-ID: <1394675038.32465.223.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 18:21 -0700, Andy Lutomirski wrote:
> On Wed, Mar 12, 2014 at 6:17 PM, Simo Sorce <ssorce@redhat.com> wrote:
> > On Wed, 2014-03-12 at 14:19 -0700, Andy Lutomirski wrote:
> >> On Wed, Mar 12, 2014 at 2:16 PM, Simo Sorce <ssorce@redhat.com> wrote:
> >>
> >> >
> >> > Connection time is all we do and can care about.
> >>
> >> You have not answered why.
> >
> > We are going to disclose information to the peer based on policy that
> > depends on the cgroup the peer is part of. All we care for is who opened
> > the connection, if the peer wants to pass on that information after it
> > has obtained it there is nothing we can do, so connection time is all we
> > really care about.
> 
> Can you give a realistic example?
> 
> I could say that I'd like to disclose information to processes based
> on their rlimits at the time they connected, but I don't think that
> would carry much weight.

We want to be able to show different user's list from SSSD based on the
docker container that is asking for it.

This works by having libnsss_sss.so from the containerized application
connect to an SSSD daemon running on the host or in another container.

The only way to distinguish between containers "from the outside" is to
lookup the cgroup of the requesting process. It has a unique container
ID, and can therefore be mapped to the appropriate policy that will let
us decide which 'user domain' to serve to the container.

Simo.

