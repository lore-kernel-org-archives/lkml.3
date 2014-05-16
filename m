Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaEPBov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 21:44:51 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:49724 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEPBou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 21:44:50 -0400
Message-ID: <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 15 May 2014 21:42:25 -0400
In-Reply-To: <20140515221551.GB13306@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LtVYn7Jpo+zOUOo88SX4"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4G1gQLH032760
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400809352.19782@U/ybBEH6CIaSTp5mgprsEg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LtVYn7Jpo+zOUOo88SX4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-05-15 at 15:15 -0700, Greg Kroah-Hartman wrote:
> On Thu, May 15, 2014 at 05:42:54PM +0000, Serge Hallyn wrote:
> > What exactly defines '"normal" use case for a container'?

> Well, I'd say "acting like a virtual machine" is a good start :)

Ok...  And virtual machines (VirtualBox, VMware, etc, etc) have hot plug
USB devices.  I use the USB hotplug with VirtualBox.  I plug a
configured USB device in and the VirtualBox VM grabs it.  Virtual
machines have loopback devices.  I've used them and using them in
containers is significantly more efficient.  VirtualBox has remote audio
and a host of other device features.

Now we have some agreement.  Normal is "acting like a virtual machine".
That's a goal I can agree with.  I want to work toward that goal of
containers "acting like a virtual machine" just running on a common
kernel with the host.  It's a challenge.  We're getting there.

> > Not too long ago much of what we can now do with network namespaces
> > was not a normal container use case.  Neither "you can't do it now"
> > nor "I don't use it like that" should be grounds for a pre-emptive
> > nack.  "It will horribly break security assumptions" certainly would
> > be.

> I agree, and maybe we will get there over time, but this patch is nto
> the way to do that.

Ok...  We have a goal.  Now we can haggle over the details (to
paraphrase a joke that's as old as I am).

> > That's not to say there might not be good reasons why this in particula=
r
> > is not appropriate, but ISTM if things are going to be nacked without
> > consideration of the patchset itself, we ought to be having a ksummit
> > session to come to a consensus [ or receive a decree, presumably by you=
 :)
> > but after we have a chance to make our case ] on what things are going =
to
> > be un/acceptable.

> I already stood up and publically said this last year at Plumbers, why
> is anything now different?

Not much really.  The reality is that more and more people are trying to
use hotplug devices, network interfaces, and loopback devices in
containers just like they would in full para or hw virt machines.  We're
trying to make them work, without it looking like a kludge.  I
personally agree with you that much of this can be done in host user
space and, coming out of LinuxPlumbers last year, I've implemented some
ideas that did not require kernel patches that achieve some of my goals.

> And this patchset is proof of why it's not a good idea.  You really
> didn't do anything with all of the namespace stuff, except change loop.
> That's the only thing that cares, so, just do it there, like I said to
> do so, last August.

> And you are ignoring the notifications to userspace and how namespaces
> here would deal with that.

That's a problem to deal with.  I don't thing anyone is ignoring them.

> > > > Serge mentioned something to me about a loopdevfs (?) thing that so=
meone
> > > > else is working on.  That would seem to be a better solution in thi=
s
> > > > particular case but I don't know much about it or where it's at.
> > >=20
> > > Ok, let's see those patches then.
> >=20
> > I think Seth has a git tree ready, but not sure which branch he'd want
> > us to look at.
> >=20
> > Splitting a namespaced devtmpfs from loopdevfs discussion might be
> > sensible.  However, in defense of a namespaced devtmpfs I'd say
> > that for userspace to, at every container startup, bind-mount in
> > devices from the global devtmpfs into a private tmpfs (for systemd's
> > sake it can't just be on the container rootfs), seems like something
> > worth avoiding.

> I think having to pick and choose what device nodes you want in a
> container is a good thing.

Both static and dynamic devices.  It's got to support hotplug.  We have
(I have) use cases.  That's what I'm trying to do with host udev rules
and some custom configurations.  I can play games with udev rules.
Maybe we can keep the user spaces policies in user space and not burden
the kernel.

> Becides, you would have to do the same thing
> in the kernel anyway, what's wrong with userspace making the decision
> here, especially as it knows exactly what it wants to do much more so
> than the kernel ever can.

IMHO, there's nothing wrong with that as long as we agree on how it's to
be done.  I'm not convinced that it can all be done in user space and
I'm not convinced that name spaced devtmpfs is the magic pill to make it
all go away either.  Making the user space make the decisions and having
the kernel enforce them is a principle worth considering.

> > PS - Apparently both parallels and Michael independently
> > project devices which are hot-plugged on the host into containers.
> > That also seems like something worth talking about (best practices,
> > shortcomings, use cases not met by it, any ways tha the kernel can
> > help out) at ksummit/linuxcon.

> I was told that containers would never want devices hotplugged into
> them.

Interesting.  You were told they (who they?) would never want them?  Who
said that?  I would have never thought that given that other
implementations can provide that.  I would certainly want them.  Seems
strange to explicitly relegate LXC containers to being second class
citizens behind OpenVZ, Parallels, BSD Gaols, and Solaris Zones.

I might believe you were never told they would need them, but that's a
totally different sense.  Are we going to tell RedHat and the Docker
people that LXC is an inferior technology that is complex and unreliable
(to quote another poster) compared to these others?  They're saying this
will be enterprise technology.  If I go to Amazon AWS or other VPS
services and compare, are we not going to stand on a level playing
field?  Admittedly, I don't expect Amazon AWS to provide me with serial
consoles, but I do expect to be able to mount file system images within
my VPS.

> What use case has this happening / needed?

Hello?  Dink...  Dink...  Is this microphone on?  I've already detailed
out a use case (serial USB console case) that I'm dealing with now.
Now, I'm dealing with it in host user space and that's probably the
correct answer there.  I probably don't need kernel space help in this
particular case.  There's still a lot of bolt holes to fill with bolts
though for the more general case.  It's not the common case but it is a
valid legitimate use case and one that would be expected of a "virtual
machine" (VirtualBox can handle it - waste of computing cycles that it
is).  The loopback device case is even more common and, currently,
rather inconsistent but strangle self consistent and workable.

In the 80/20 case, I agree we can and should deal with this in the host
user space as much as possible.  That's the realm I'm working within.
Seth and others seem to want more in the namespace region and I'm not
convinced.  But, I'm not convinced we can accomplish everything in user
space either.

We've got use cases and we've got problem sets.  Don't give into
confirmational bias and automatically discount the use cases that have
been mentioned and then assume there are none.  I don't know if Seth's
paths are part of the answer or not.  I'm not pro Seth's patches or
against Seth's patches but we've got a need in search of solutions.

> thanks,

> greg k-h

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-LtVYn7Jpo+zOUOo88SX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3VtAcDrlnVnRif/AQhmPAf/Xb09AbjTfV2TO9N8TUKr4XQ7B0dJr4a1
oWk9j44wVk+4Mp3OluRa1TGfJ4K1EsuW9Vti3fQ8p7iRF9VTNZuLjXGgzTA9bI3H
s4ihRj0LqKJqkVuLEixCCeCfAG0ZYTEy0AZpsCgVGDVyrO4yKwmEZriSJByoEv83
ln3WEeU+Q6+0hBEbwfj32fQFxE8oDv7vzmIyL6KlHLN8n+dbgfzMR/a0BTnxvNMT
dlqG4B/O3m3j7I7MgvhxQ+5FAo2/PvTsf+hief4sJDgTk2B/A7Oi7qXYbyXUWMMl
/Ikn1nLOO/K934GXqMP6R5lAg6B0tp9tqcXikob2A20yrmUVZ/s7Dg==
=rYA0
-----END PGP SIGNATURE-----

--=-LtVYn7Jpo+zOUOo88SX4--

