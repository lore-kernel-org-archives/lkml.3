Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaCMSsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:48:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50465 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaCMSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:48:34 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: next-20140312 - build error in drivers/acpi/sleep.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1394736511_1654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Mar 2014 14:48:31 -0400
Message-ID: <22429.1394736511@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1394736511_1654P
Content-Type: text/plain; charset=us-ascii

Seen in the most recent linux-next with a CONFIG_SUSPEND=n .config:

  CC      drivers/acpi/sleep.o
drivers/acpi/sleep.c: In function 'acpi_sleep_init':
drivers/acpi/sleep.c:808:2: error: implicit declaration of function 'acpi_sleep_state_supported' [-Werror=implicit-function-declaration]
  if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
  ^
cc1: some warnings being treated as errors
make[2]: *** [drivers/acpi/sleep.o] Error 1
make[1]: *** [drivers/acpi] Error 2
make: *** [drivers] Error 2

Function is defined inside a #ifdef CONFIG_SUSPEND, but used outside of
one in acpi_sleep_init().

git blame points at commit eaa54ccbc:

commit eaa54ccbcf81de987e6978ad457cc9e425b7a8db
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Mar 11 14:08:58 2014 +0100

    ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

    If the HW Reduced ACPI mode bit is set in the FADT, ACPICA uses
    the optional sleep control and sleep status registers for making
    the system enter sleep states (including S5), so it is not possible
    to use system sleep states or power it off using ACPI if the HW
    Reduced ACPI mode bit is set and those registers are not available.

    For this reason, add a new function, acpi_sleep_state_supported(),
    checking if the HW Reduced ACPI mode bit is set and whether or not
    system sleep states are usable in that case in addition to checking
    the return value of acpi_get_sleep_type_data() and make the ACPI
    sleep setup routines use that function to check the availability of
    system sleep states.


--==_Exmh_1394736511_1654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUyH9fgdmEQWDXROgAQJ44A/8DdPmfycJj10J17fhHCKfu6Cv20zcx0IH
OfsCatKlhvfw4ifOvlzCw4lHMl7XhR3F6fVwh7HW6vTau1aD//7acHvZ9vyp9hEO
nr0WZrjnd7E5lR/lq0tB91jGnNzsoHkdqxT/z3yHdc/ql5Yus6/b8uDGLrnUtkLD
4tvGCY6BXy4nVJqxGkh63ddbtt4ZqghA191NFXTB0TsSg5NPba345IKai32Dmqsu
G6E4fIi4qDMx5ggbChJuHIfNlAyuGWaCvjX+LffnrWrh2eFGlKYZrf99bC41h2yg
H9PazTMkWnpw+uUbA2dRylqrI/q7XoaeSPXxM/8T2LYuqy31hWQuhTh9Q9vnzjpl
/iTT4jC+ulATYxHzdaK3YN8R4XnMEi86LSwqUWgu1xHOSNV0K8en2ZD/Q1INqv8e
2qSiFbNuxZQtWLjxudoHUbxqvswRXrZM2tKl5M8r9GfSYZp84fFNcT5Q4yxhEBDA
78AOTMKaKFd7MfcB32k7NPw+MybcGqz4gSnriDAtqJQH+GteePenb+xNp5dcCfOX
8lUVnIboG7NgbzYwgHOlpG7nMRKiU87YLBMWSXAbR/b1eQVOQQUcz00g5habrzbQ
s3KgtA1Mq8y9MaSvLimgPE1OxYGSC0/Dz4Sqa+IlKrzkOD3f4dS+XaT9+RCwfZ3E
J1ZCV+QhmGg=
=COpF
-----END PGP SIGNATURE-----

--==_Exmh_1394736511_1654P--
