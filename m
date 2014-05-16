Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbaEPToi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:44:38 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:51957 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaEPToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:44:37 -0400
Message-ID: <1400269360.3540.26.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Date: Fri, 16 May 2014 15:42:40 -0400
In-Reply-To: <1400268008.2221.84.camel@dabdike.int.hansenpartnership.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com>
	 <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
	 <1400268008.2221.84.camel@dabdike.int.hansenpartnership.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-mN6jyfpTloHzgihw84hk"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4GJgl0L017982
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400874169.24228@Gt27X5RPoQgoMjEXyDrPVg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mN6jyfpTloHzgihw84hk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-05-16 at 12:20 -0700, James Bottomley wrote:
> On Thu, 2014-05-15 at 21:42 -0400, Michael H. Warfield wrote:
> > On Thu, 2014-05-15 at 15:15 -0700, Greg Kroah-Hartman wrote:
> > > > PS - Apparently both parallels and Michael independently
> > > > project devices which are hot-plugged on the host into containers.
> > > > That also seems like something worth talking about (best practices,
> > > > shortcomings, use cases not met by it, any ways tha the kernel can
> > > > help out) at ksummit/linuxcon.
> >=20
> > > I was told that containers would never want devices hotplugged into
> > > them.
> >=20
> > Interesting.  You were told they (who they?) would never want them?  Wh=
o
> > said that?  I would have never thought that given that other
> > implementations can provide that.  I would certainly want them.  Seems
> > strange to explicitly relegate LXC containers to being second class
> > citizens behind OpenVZ, Parallels, BSD Gaols, and Solaris Zones.

> That would probably be me.  Running hotplug inside a container is a
> security problem and, since containers are easily entered by the host,
> it's very easy to listen for the hotplug in the host and inject it into
> the container using nsenter.

In all virtualization...  The host, particularly root on the host,
exists as deus ex machina, the "god outside the machine".  They are at
my mercy.  Even hardware virtualization can not protect you from the
host.  You wanna hear some frightening talks on virtualization, catch
Joanna (miss little blue pill) Rutkowska some time.  I'm particularly
interesting in her takes on the "anti evil-maid attacks" and I sat in on
her talks on the "north bridge" and "south bridge" malware evasion
techniques.  She's a good speaker who makes powerful points that makes
you sweat but is pleasant in face to face conversation.  I've played
with her Qubes distribution a couple of times and the way it works with
the TPM to insure a secure boot is interesting.  But that's a completely
different topic on trusted computing.

OTOH, there are plenty of other things to worry about in all forms of
virtualization.  At Internet Security Systems, where I was a founder,
fellow, and "X-Force Senior Wizard", we were looking at the ability to
leak information through the USB subsystem.  No isolation is perfect,
especially when you have USB enabled.

But that's my turf.

> I don't think the intention is to label anyone's implementation as
> preferred.  What this shows, I think, is that we all have different
> practises when it comes to setting up containers.  Some are necessary
> because our containers are different.  Some could do with serious
> examination to see if there's really a best way to do the action which
> we would then all use.

And I hope to contribute to the discussion of said actions.

> > I might believe you were never told they would need them, but that's a
> > totally different sense.  Are we going to tell RedHat and the Docker
> > people that LXC is an inferior technology that is complex and unreliabl=
e
> > (to quote another poster) compared to these others?  They're saying thi=
s
> > will be enterprise technology.  If I go to Amazon AWS or other VPS
> > services and compare, are we not going to stand on a level playing
> > field?  Admittedly, I don't expect Amazon AWS to provide me with serial
> > consoles, but I do expect to be able to mount file system images within
> > my VPS.

> Well, that's another nasty, isn't it.  We all have different ways of
> coping with mount in the container.  I think at plumbers we need to sit
> down with some of this plumbing and work out which pipes carry the same
> fluids and whether we could unify them.

Concur

> As an aside (probably requiring a new thread) we were wondering about
> some type of notifier on the mount call that we could vector into the
> host to perform the action.  The main issue for us is mount of procfs,
> which really needs to be a bind mount in a container.  All of this led
> me to speculate that we could use some type of syscall notifier
> mechanism to manage capabilities in the host and even intercept and
> complete the syscall action within the host rather than having to keep
> evolving more an more complex kernel drivers to do this.

Interesting.  That could be very useful.  That might even help with the
loop device case where the mounts have to go through loop devices for
things like file system images and builds.  Very interesting...

> James

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-mN6jyfpTloHzgihw84hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3ZqMMDrlnVnRif/AQgbswf/ZO8kOZVvNQA9Z1/DDtGLA09m2RsQ6FW8
ifzZwN5Tcic2QKNUNelgFuIHCzzgtn2gFxXUHLGGiShuMLvsGgUjdvn3Fp9nJ+Ai
d+08gEqIR+m4C6SFlU7z5T4h1dWuv4pNKxg/S4joSsPy/0aLcYVSsg3GrVxKN6yI
VzxjHIBP19j7TYlhD7BLX5MPqOtkLCOtr7OH4zJVH+66oIQNj1urwWrp7bkp65YX
xmMkc2dSu7NDiR7u2zu6Ji2mSIV6l2PKT5JlbAryjhRtbpguXXUXJFxrR+VmjiJc
YnwP+OEG8+lXui8fpc7kvQimIBTiyKXGNRDg45cu3Z3Mp7hOYL7HOQ==
=IH4y
-----END PGP SIGNATURE-----

--=-mN6jyfpTloHzgihw84hk--

