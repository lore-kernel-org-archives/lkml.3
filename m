Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3DMBFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3DMBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:05:23 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xQ1lwhnwZLAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OnWC7ifjaPkA:10 a=VwQbUJbxAAAA:8 a=c6Xcn-J73k9pGeghwswA:9 a=QEXdDO2ut3YA:10 a=HPpmTwGnVhOuWmRvxBMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130413010121.658707789@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Apr 2013 21:01:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v3.9-rc7] tracing: Another fix by Namhyung
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Namhyung found and fixed another nasty bug, where you can crash the
kernel with: echo 1234 | tee -a /sys/kernel/debug/tracing/set_ftrace_pid

Luckily, only root has permissions to write to that file.

I also added a fix on top of Namhyung's as his patch added a reference
outside of the DYNAMIC_FTRACE to a function that is only defined
in DYNAMIC_FTRACE. This fixes compiling with FUNCTION_TRACING and
without DYNAMIC_FTRACE (although I don't know who does that anymore).

-- Steve

Please pull the latest trace-fixes-v3.9-rc-v3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.9-rc-v3

Head SHA1: 0e1bb617b40659414778baf3203c2ea0dcda1ca7


Namhyung Kim (1):
      tracing: Fix possible NULL pointer dereferences

Steven Rostedt (Red Hat) (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

----
 include/linux/ftrace.h     |    3 ++-
 kernel/trace/ftrace.c      |   36 ++++++++++++++++++------------------
 kernel/trace/trace_stack.c |    2 +-
 3 files changed, 21 insertions(+), 20 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRaK9PAAoJEOdOSU1xswtMGPMH/3FgGnUMjZmR/mNbD7ka8m2s
ku+7FwU4e3kwOorhoB/YQ8wSpf1fevUzb/luTWKheptLAFDosHHfFokl91tnG0ay
dRCZxJ9xmuiNfY3EWAa8EXQB5J1QE8qZJ3ZoFU2wLEYlN2rRGkOm0vz3YV4a/G+3
HGXkLxQ5wBqRjDhd/2bwvZdSXEZJqqaMeHLb7XXJ7ZUnpWTe+8AH40KxrHiphUyr
QWs9vIS/HZqHJ7TOHQ6YRwy3gJ2J+3QSDHpnRXNOXtU/PBzuHQcP8YdAhNGODlp4
C/oH0KslAmyfWEMoR9cRJuMwf71tT2w5UatDdah36HqOHjyc1RyFUo6afluxg/E=
=spwx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
