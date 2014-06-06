Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaFFH20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:28:26 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:27788
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbaFFH2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:24 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406B88FS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Thread-Topic: [PATCH v2 0/14] input: cyapa: re-architecture driver to
 support multi-trackpads in one driver
Thread-Index: Ac+BWOF9//n+u9yTR6yWTSDzhXEDgg==
Date: Fri, 6 Jun 2014 07:28:22 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406B88F@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406B88F@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406B88FS04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch set is made based on kernel 3.15.0-rc8.
It's aimed to re-architecture the cyapa driver to support
old gen3 trackpad device and new gen5 trackpad device in one
cyapa driver for easily productions support based on
customers' requirements, and add sysfs functions and interfaces
supported that required by users and customers.
Because the earlier gen3 and the latest gen5 trackpad devies using
two different chipsets, and have different protocol and interfaces.
If supported these two trackpad devices in two different drivers, then
it will be difficult to manage productions and later firmware updates.
it will cause customer don't know which one to use and update
because these two trackpad devices have been used and integrated
in same one productions at a time, so must to support these two trackpad
devices in same on driver.

The new architecture is made of:
cyapa.c - the core of the architecture, supply interfaces and
functions to system and read trackpad devices.
cyapa_gen3.c - functions supported for gen3 trackpad devices,
cyapa_gen5.c - functions supported for gen5 trackpad devices.

Beside this introduction patch, it has 14 patches listed as below.
For these patches each one is patched based on previous one.

patch 1/14: re-architecture cyapa driver with core functions,
and applying the device detecting function in async thread to speed
up system boot time.

patch 2/14: add cyapa driver power management interfaces supported.

patch 3/14: add cyapa driver runtime power management interfaces supported.

patch 4/14: add cyapa key function interfaces in sysfs system.
Including read firmware version, get production ID, read baseline,
re-calibrate trackpad baselines and do trackpad firmware update.

patch 5/14: add read firmware image and read raw trackpad device'
sensors' raw data interface in debugfs system.

patch 6/14: add gen3 trackpad device basic functions supported.

patch 7/14: add gen3 trackpad device firmware update function supported.

patch 8/14: add gen3 trackpad device report baseline and do force
re-calibrate functions supported.

patch 9/14: add gen3 trackpad device read firmware image function supported=
.

patch 10/14: add gen5 trackpad device basic functions supported.

patch 11/14: add gen5 trackpad device firmware update function supported.

patch 12/14: add gen5 trackpad device report baseline and do force
re-calibrate functions supported.

patch 13/14: add gen5 trackpad device read firmware image and report
sensors' raw data values functions supported.

patch 14/14: add function to monitor LID close event to off trackpad device=
.
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406B88FS04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IjlwAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADI5NzU2RjU4
ODg0RDRCNDFCMDlFODZEOUM3NkRCMEE4AD0HAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgAGAAcA
HAAWAAUALwEBIIADAA4AAADeBwYABgAHABwAFgAFAC8BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAF4AAABbUEFUQ0ggdjIgMC8xNF0gaW5wdXQ6IGN5YXBhOiByZS1hcmNo
aXRlY3R1cmUgZHJpdmVyIHRvIHN1cHBvcnQgbXVsdGktdHJhY2twYWRzIGluIG9uZSBkcml2ZXIA
EyEBA5AGAIgSAABLAAAAAgF/AAEAAABCAAAAPDc3QkM3MjVDOTA2Mjc2NEY4NzRENzlGNTFFMUYx
QThGNDQwNkI4OEZAUzA0LU1CWDAxLTAxLnMwNC5sb2NhbD4AAAALAB8OAQAAAAIBCRABAAAA+QUA
APUFAACiDQAATFpGdf177WxhAApmYmlkBAAAY2PAcGcxMjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gK
wHNldDAg7wdtAoMAUBFNMgqABrQCgJZ9CoAIyDsJYjE5DsC/CcMWcgoyFnECgBViKgmwcwnwBJBh
dAWyDlADYHOibwGAIEV4EcFuGDBdBlJ2BJAXtgIQcgDAdH0IUG4aMRAgBcAFoBtkZJogA1IgECIX
slx2CJDkd2sLgGQ1HVME8AdADRdwMApxF/Jia21rBnMBkAAgIEJNX0LgRUdJTn0K/AHxC/FVEkBo
BAAgCrB0EcAgHRIBICHBAMABACBiYacSABxgAiAgawSRZQMgADMuMTUuMC1yoGM4LlxsC4BlCoD4
SXQnBCALcAeAHGAYkFogCXAtCsARwGkQIGMmdAhwGeB0aBngY3lyYQqwIGQFEBoxJdJz+HVwcAkR
JMUG8BxgGDHmMxzAGHBjawqwHGABAP0dYGMZ4ABwHGAYUAfgGDHuNSm/C4AjYWUkxSdbGuFsIGUj
IAMQeSHgA2Bk+nUmsGkCIAQgKFUjByz2TnUfYANwBJBzJyYBcZx1aQlwB4ACMHMsKrNjItAcYHN5
cwPQHHB13m4vNSrCC4AboWYA0AeQfyTFKFUlshHQBUAxxRxgYr8uwDEgMXEqszEXJLZCBZDuYTch
JwMucHIk0BuxKXP/KsInEgtgECAfYCs/HWEEIMsxIAuAZyTFdHcl8A3g3wEgBJAyQRvQIbBwEgEy
df8R0BowPZku4RiQCOE0HSS3/mYoRjXjB5Am8T1xKc0EIH8skT1sJ7QycScRMJYmgCA1A/BsAyBi
P1QOUHVs9wVAJeEDgWEZ0S7qKsI64nMuETIAbXcKwBngKGBkfzryJLZG1jj0MRYnoAIgJ9EFQGtu
bwfgdyGwIiH/LMEl0jkSKsJKtCTFR1A49/9DD0QVPyNHUAnwNxIywTQ1nwnAOvELMEZ1A6BzYQeA
/04TSMsFQCeQL0AHgDKAGSD/IrAxISgZUF8i0CTFRAlUhf8npSS2JMUhoBngKwImSyKWhRkwOiz6
LmMgLScE/wWwXXInAyZKVmEoYS6xNGj/KrIkxTOIKCIzMBAgHLAqwt8JcCohUQ4ktidTXylyXoPf
M4g1eC4yKX9EMixlXiRA/2Z/Z4wrfzhHOGcAkCLhJxD/IcE0YS73IeQygEbREdAEIPwxNCHkB5Ek
0GNhMsEEIOtHUAkAdyS2RgWxV7RxVv8ucE31IcY2wiMmLuAqYQhgTwQgLMFa3SH0MS9xIDr/Jg8n
WwPwJxBfBDOHaYYyo/9g0jzBJwMqVQEAJpJ8sjOGeyyCIyB5M6AnAWP0KDFw/wngU9YoYGM2BuBA
MFYTdv+9IhIyeFMy4idbKIB3G7G/SFQyMmEaNXeB/yISM4Nf/SfTcjOQViKEr4W/hs93xv40iG0j
oC7AfklhR1RSMzP/Y0QktzOgCkAN4HzBY/NKJz9Fwi9RMoAYMD/zb8ZJRH8ygGPzIxIk0mmGJhEe
UWn+YlOSK4iVZjQETRAriEot+4yfIhI1iGeSfAdwSIJjt/cYcAfgKc0nNQYJ8BkgMYM/niFK0SeQ
NGcsggEAYnX2Z5DPd3s2iGdoPyqCIxHvDlBq74xvd9U3o/8p+0ot9344pt93eziozyn7CXAv1/8k
0phWGuEqkJX/q3mmv3ddfjmuL689nG+rn7Qfd+Uw/7WabK+lz7lPd3x4RLufqi//qz++P3eLg0jA
v6/PsN+x7/+9f8P/d9aIWMYvtz+dGyiJ/5/Pk0AHQApQM2rLH3d8jejffkdIIgIgJoAFsUyU0BvQ
/wkAOSEqYD4CJeEZMF9xKdz/JLYhoweBVICdVQBwLsAYgP8BkBHAMjMisS7AG+EBkCyR7EN5djEE
ESgFsSaAL4LOYm7RBzAIgXMpG9JHsL8BAInhB0AsgRrkL1EulMD/QhBwtVJjCXAqkCfRNEIuYHpy
A2ByMoALUC5xKqFk3x1gOSXRQQSBNBRtJaEHMP8QIC6xAQAecJcC2jkkthVCAecQAAAAHwBCAAEA
AAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAfAGUAAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBl
AHMAcwAuAGMAbwBtAAAAAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAFgAAAAAAAAA
gSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABs
AEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwACXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIA
ZQBzAHMALgBjAG8AbQAAAAAAHwDlXwEAAAAqAAAAcwBpAHAAOgBkAHUAZABsAEAAYwB5AHAAcgBl
AHMAcwAuAGMAbwBtAAAAAAAfABoMAQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AHwwBAAAA
IgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBU
AFAAAAAAAAIBGQwBAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAA
RAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAFdAQAA
ACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAPg/AQAAABQAAABEAHUA
ZABsAGUAeQAgAEQAdQAAAB8AI0ABAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBv
AG0AAAAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAWAAAAAAAAACBKx+kvqMQGZ1u
AN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcABy
AGUAcwBzAC4AYwBvAG0AAAAfAAldAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMA
bwBtAAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAAS
AAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAA
AAApdW9YiE1LQbCehtnHbbCoAwAXAAEAAABAADkAAC875ViBzwFAAAgwZao85ViBzwELACkAAAAA
AAsAIwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcA
dQBhAGcAZQAAAAAAAQAAABoAAAB6AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAA
AAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAALwAAABbAFAAQQBUAEMASAAgAHYAMgAgADAA
LwAxADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEAcABhADoAIAByAGUALQBhAHIAYwBoAGkAdABl
AGMAdAB1AHIAZQAgAGQAcgBpAHYAZQByACAAdABvACAAcwB1AHAAcABvAHIAdAAgAG0AdQBsAHQA
aQAtAHQAcgBhAGMAawBwAGEAZABzACAAaQBuACAAbwBuAGUAIABkAHIAaQB2AGUAcgAAAB8APQAB
AAAAAgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAAAAHPgVjhff/5/rvck0eslk0g84VxA4IAAB8A
cAABAAAAvAAAAFsAUABBAFQAQwBIACAAdgAyACAAMAAvADEANABdACAAaQBuAHAAdQB0ADoAIABj
AHkAYQBwAGEAOgAgAHIAZQAtAGEAcgBjAGgAaQB0AGUAYwB0AHUAcgBlACAAZAByAGkAdgBlAHIA
IAB0AG8AIABzAHUAcABwAG8AcgB0ACAAbQB1AGwAdABpAC0AdAByAGEAYwBrAHAAYQBkAHMAIABp
AG4AIABvAG4AZQAgAGQAcgBpAHYAZQByAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMA
OQAwADYAMgA3ADYANABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBC
ADgAOABGAEAAUwAwADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAA
AwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAA
AABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUA
AIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAA
AByBAAAAAAAAQAAHMCkZKORYgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5
MCBRRp20pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD
/MNFAAAAAB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAA
AADAAAAAAAAARgAAAAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2
AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAA
SQBJAD0AMAAxAEMARgA4ADEANQA4AEUAMQA3AEQARgBGAEYAOQBGAEUAQgBCAEQAQwA5ADMANAA3
AEEAQwA5ADYANABEADIAMABGADMAOAA1ADcAMQAwADMAOAAyADsAVgBlAHIAcwBpAG8AbgA9AFYA
ZQByAHMAaQBvAG4AIAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0
AGEAZwBlAD0ASAA0AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYA
AAAAAMAAAAAAAABGAAAAACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAAD
AACAAyAGAAAAAADAAAAAAAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSB
AAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAA
RgAAAAApgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAAB
AAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAA
AAAAAABGAAAAAAOBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAG
AAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAA
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAABAAACACCAGAAAAAADAAAAAAAAARgAAAAC/
hQAAMKP0KVeBzwEDAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0A
aABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAA
ACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAHgAAAFsAMQAwAC4A
MwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAAWfE=

--_000_77BC725C9062764F874D79F51E1F1A8F4406B88FS04MBX0101s04lo_--
