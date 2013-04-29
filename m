Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3D2TwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:52:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab3D2TwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:52:04 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zj-aDniqNm4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PSvuwpntFfAA:10 a=4kDAWb-mnydJKQ6nccMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=BSNKARNNu79jbrAcZAEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130429195201.462539345@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Apr 2013 15:51:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: [PATCH 1/2] localmodconfig: Add debug prints for dependencies of module configs
References: <20130429195100.202681236@goodmis.org>
Content-Disposition: inline; filename=0001-localmodconfig-Add-debug-prints-for-dependencies-of-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

When a config for a module is added to the list to save in the final
config file, add a print to show what dependencies are used. This is
useful to debug when a config is disabled by the make oldconfig after
localmodconfig is finished.

This print only appears if the environment variable LOCALMODCONFIG_DEBUG
is defined.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 3368939..343a568 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -396,6 +396,15 @@ foreach my $module (keys(%modules)) {
 	foreach my $conf (@arr) {
 	    $configs{$conf} =3D $module;
 	    dprint "$conf added by direct ($module)\n";
+	    if ($debugprint) {
+		my $c=3D$conf;
+		$c =3D~ s/^CONFIG_//;
+		if (defined($depends{$c})) {
+		    dprint " deps =3D $depends{$c}\n";
+		} else {
+		    dprint " no deps\n";
+		}
+	    }
 	}
     } else {
 	# Most likely, someone has a custom (binary?) module loaded.
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRfs9hAAoJEOdOSU1xswtM/kwH/3YTLGutkGz6EBA7Kp50cKw+
Xm/S4vmnpy3Qy9OZqoKYOYuBuP5MzcKnYo8gT9bGlUysO5IJsK32906/ycwikyph
uPZEXqKYyoPEAM03CFSlMR9DVGIbhln4iVMaKa+UkOuOVf6BKiAuv24Bswa5VXg8
b0E/V2agiNeZsUHz1s01FU/fqzDlRvIlEMZY77nnPDn1VkFyO6ntltniUOm/XfyD
QhImfViKUvvts2K9JpoS5hmqTcMwILIqzEwXnPMuPMT7TOOwE9C8niUut/sBNwxW
9HlBpcYNgbuUY5ys0Ql7jWqapQZdOQ4HFIfw4avkVbtI+iwmpcZ/qzonywSojb4=
=8Bla
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
