Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbaGRITM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:19:12 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64256 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaGRITH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:19:07 -0400
Message-ID: <53C8D874.9090601@monstr.eu>
Date: Fri, 18 Jul 2014 10:19:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 06/27] microblaze: ftrace: Add call to ftrace_graph_is_dead()
 in function graph code
References: <20140626165221.736847419@goodmis.org>	<20140626165849.119568888@goodmis.org> <20140709100310.3c3b25ff@gandalf.local.home>
In-Reply-To: <20140709100310.3c3b25ff@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jotGSWd0QMuNBtdMKqdovla59LUAjOFIV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jotGSWd0QMuNBtdMKqdovla59LUAjOFIV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On 07/09/2014 04:03 PM, Steven Rostedt wrote:
> Michal,
>=20
> Can you ack this please?
>=20
> -- Steve
>=20
>=20
> On Thu, 26 Jun 2014 12:52:27 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> ftrace_stop() is going away as it disables parts of function tracing
>> that affects users that should not be affected. But ftrace_graph_stop(=
)
>> is built on ftrace_stop(). Here's another example of killing all of
>> function tracing because something went wrong with function graph
>> tracing.
>>
>> Instead of disabling all users of function tracing on function graph
>> error, disable only function graph tracing. To do this, the arch code
>> must call ftrace_graph_is_dead() before it implements function graph.
>>
>> Cc: Michal Simek <monstr@monstr.eu>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  arch/microblaze/kernel/ftrace.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/=
ftrace.c
>> index bbcd2533766c..fc7b48a52cd5 100644
>> --- a/arch/microblaze/kernel/ftrace.c
>> +++ b/arch/microblaze/kernel/ftrace.c
>> @@ -27,6 +27,9 @@ void prepare_ftrace_return(unsigned long *parent, un=
signed long self_addr)
>>  	unsigned long return_hooker =3D (unsigned long)
>>  				&return_to_handler;
>> =20
>> +	if (unlikely(ftrace_graph_is_dead()))
>> +		return;
>> +
>>  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
>>  		return;
>> =20
>=20

sorry for delay. Here is mine.

Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jotGSWd0QMuNBtdMKqdovla59LUAjOFIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPI2HQACgkQykllyylKDCGjVwCfUPgO2lm0Cn0pyUjgmc+Gv4pu
tQEAni/St935oBXwqaMYVGeuUIPyltIz
=phGk
-----END PGP SIGNATURE-----

--jotGSWd0QMuNBtdMKqdovla59LUAjOFIV--
