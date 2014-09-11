Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaIKNrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:47:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46018 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaIKNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:46:58 -0400
Message-ID: <1410443212.5187.59.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning
 with a '.'
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 11 Sep 2014 09:46:52 -0400
In-Reply-To: <CACE9dm-4tURS7ZvJ45W81L5d3yaO8VDyvrcn1-SU_6UsHkmuQw@mail.gmail.com>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
	 <20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
	 <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <27732.1410437386@warthog.procyon.org.uk>
	 <CACE9dm-4tURS7ZvJ45W81L5d3yaO8VDyvrcn1-SU_6UsHkmuQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091113-8236-0000-0000-0000054FF639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 15:27 +0300, Dmitry Kasatkin wrote: 
> On 11 September 2014 15:09, David Howells <dhowells@redhat.com> wrote:
> > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> >> On Wed, 2014-09-10 at 19:36 -0400, Mimi Zohar wrote:
> >> > On Wed, 2014-09-10 at 22:22 +0100, David Howells wrote:
> >> > > Reinstate the generation of EPERM for a key type name beginning with a
> >> > > '.' in a userspace call.  Types whose name begins with a '.' are
> >> > > internal only.
> >>
> >> After re-reading your comment and looking at the different types,
> >> testing for dot prefixed types now makes sense.  Both dot prefixed types
> >> and keyring names are reserved for the kernel.
> >
> > Are you withdrawing your objection, then?

The misunderstanding was based on being told that dot prefixed keyrings
were protected, but in fact the only dot prefix code was here in
key_get_type_from_user().

The concept of dot prefixing should probably be documented either in the
code and/or documentation.  At this point, both types and keyring names
are reserved.

Mimi

