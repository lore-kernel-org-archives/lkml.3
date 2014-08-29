Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaH2K5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:57:12 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:39117 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaH2K5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:57:09 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Iain Paton <ipaton0@gmail.com>
CC: Fabio Estevam <festevam@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREAAM+aMA//6IPID//QHtAP/4Df8A/+ub5xD/1wicgP+rMUjQ/1SejoD+qU6QAP1RkiKw+p8SkAD1PiHLAOp6Jo+A1PDsGICp4OdZgNPBHUWAp3qIGIDO9OT5gJ3mhc5Q
Date: Fri, 29 Aug 2014 10:57:05 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB80435790DF@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140806125550.GO30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
 <20140807121248.GY30282@n2100.arm.linux.org.uk>
 <20140808180900.GG30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
 <53F11FF6.8030303@gmail.com>
 <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com>
 <53F2E89B.80009@gmail.com> <53F5BE3D.5070209@gmail.com>
 <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
 <53F71D1B.8090004@gmail.com>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043578CB2@ALVA-EXMB04.alv.autoliv.int>
 <53FDB649.2070506@gmail.com>
In-Reply-To: <53FDB649.2070506@gmail.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1018-20914.006
x-tm-as-result: No--29.911800-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: multipart/mixed;
	boundary="_002_C4A61A5CA4AD2246942F4BA6F20ACB80435790DFALVAEXMB04alvau_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_C4A61A5CA4AD2246942F4BA6F20ACB80435790DFALVAEXMB04alvau_
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Iain,

> Interesting. We obviously have some differences in how we boot, my
> changes to your config to get it to boot basically amount to reverting =
the
> patch you attached and then enabling sata and mmc. So far I've been una=
ble
> to get your config to fail.

Our version of U-boot doesn't support specifying a device tree separate f=
rom
the kernel, so we append it to the end of the kernel binary. We also enab=
le
automatic configuration of IP addresses (CONFIG_IP_PNP). Our bootargs are=
:
console=3Dttymxc1,115200
ip=3D192.168.2.157:192.168.2.1:192.168.2.1:255.255.255.0:armcard:eth0:on
earlyprintk enable_wait_mode=3Doff

> It would be good to know what makes my config work for you, I don't thi=
nk
> I've done anything special with it.

With a couple of modifications (attached) we have been able to get your
config running on our Zynq boards as well, solving our ethernet issues.

The serial port and ethernet are essentially the only things we use. No d=
isks,
no graphics, no USB, etc. which is why we tried to reduce the kernel
configuration to a bare minimum. We have no idea which disabled and/or
enabled options that are causing the stalls.

Best regards,
Mattis Lorentzon

***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this lin=
k:
http://www.autoliv.com/disclaimer.html
***************************************************************

--_002_C4A61A5CA4AD2246942F4BA6F20ACB80435790DFALVAEXMB04alvau_
Content-Type: application/octet-stream; name="config.patch"
Content-Description: config.patch
Content-Disposition: attachment; filename="config.patch"; size=2670;
	creation-date="Fri, 29 Aug 2014 10:48:08 GMT";
	modification-date="Fri, 29 Aug 2014 10:46:02 GMT"
Content-Transfer-Encoding: base64

MzcyYzM3Mgo8IENPTkZJR19BUkNIX1pZTlE9eQotLS0KPiAjIENPTkZJR19BUkNIX1pZTlEgaXMg
bm90IHNldAozOTlkMzk4CjwgIyBDT05GSUdfQ1BVX0JJR19FTkRJQU4gaXMgbm90IHNldAo0MTZk
NDE0CjwgQ09ORklHX0FSQ0hfU1VQUE9SVFNfQklHX0VORElBTj15CjQyN2Q0MjQKPCBDT05GSUdf
SUNTVD15CjQzMmQ0MjgKPCBDT05GSUdfQVJNX0FNQkE9eQo1NDMsNTQ2YzUzOQo8IENPTkZJR19B
Uk1fQVBQRU5ERURfRFRCPXkKPCBDT05GSUdfQVJNX0FUQUdfRFRCX0NPTVBBVD15CjwgQ09ORklH
X0FSTV9BVEFHX0RUQl9DT01QQVRfQ01ETElORV9GUk9NX0JPT1RMT0FERVI9eQo8ICMgQ09ORklH
X0FSTV9BVEFHX0RUQl9DT01QQVRfQ01ETElORV9FWFRFTkQgaXMgbm90IHNldAotLS0KPiAjIENP
TkZJR19BUk1fQVBQRU5ERURfRFRCIGlzIG5vdCBzZXQKNjQ0LDY0N2M2MzcKPCBDT05GSUdfSVBf
UE5QPXkKPCAjIENPTkZJR19JUF9QTlBfREhDUCBpcyBub3Qgc2V0CjwgIyBDT05GSUdfSVBfUE5Q
X0JPT1RQIGlzIG5vdCBzZXQKPCAjIENPTkZJR19JUF9QTlBfUkFSUCBpcyBub3Qgc2V0Ci0tLQo+
ICMgQ09ORklHX0lQX1BOUCBpcyBub3Qgc2V0CjEwMTJkMTAwMQo8ICMgQ09ORklHX0NBTl9YSUxJ
TlhDQU4gaXMgbm90IHNldAoxNDU0LDE0NTVjMTQ0Mwo8IENPTkZJR19ORVRfQ0FERU5DRT15Cjwg
Q09ORklHX01BQ0I9eQotLS0KPiAjIENPTkZJR19ORVRfQ0FERU5DRSBpcyBub3Qgc2V0CjE1MTAs
MTUxMWQxNDk3CjwgQ09ORklHX05FVF9WRU5ET1JfWElMSU5YPXkKPCAjIENPTkZJR19YSUxJTlhf
RU1BQ0xJVEUgaXMgbm90IHNldAoxNzg5ZDE3NzQKPCAjIENPTkZJR19TRVJJT19BTUJBS01JIGlz
IG5vdCBzZXQKMTgyNSwxODI2ZDE4MDkKPCAjIENPTkZJR19TRVJJQUxfQU1CQV9QTDAxMCBpcyBu
b3Qgc2V0CjwgIyBDT05GSUdfU0VSSUFMX0FNQkFfUEwwMTEgaXMgbm90IHNldAoxODMzLDE4MzRk
MTgxNQo8IENPTkZJR19TRVJJQUxfVUFSVExJVEU9eQo8IENPTkZJR19TRVJJQUxfVUFSVExJVEVf
Q09OU09MRT15CjE4NDMsMTg0NGMxODI0CjwgQ09ORklHX1NFUklBTF9YSUxJTlhfUFNfVUFSVD15
CjwgQ09ORklHX1NFUklBTF9YSUxJTlhfUFNfVUFSVF9DT05TT0xFPXkKLS0tCj4gIyBDT05GSUdf
U0VSSUFMX1hJTElOWF9QU19VQVJUIGlzIG5vdCBzZXQKMTkwN2QxODg2CjwgIyBDT05GSUdfSTJD
X0NBREVOQ0UgaXMgbm90IHNldAoxOTE0ZDE4OTIKPCAjIENPTkZJR19JMkNfTk9NQURJSyBpcyBu
b3Qgc2V0CjE5NTJkMTkyOQo8ICMgQ09ORklHX1NQSV9QTDAyMiBpcyBub3Qgc2V0CjIwMzhkMjAx
NAo8ICMgQ09ORklHX0dQSU9fUEwwNjEgaXMgbm90IHNldAoyMDQxZDIwMTYKPCAjIENPTkZJR19H
UElPX1hJTElOWCBpcyBub3Qgc2V0CjIyNDVkMjIxOQo8ICMgQ09ORklHX0FSTV9TUDgwNV9XQVRD
SERPRyBpcyBub3Qgc2V0CjI2NTJkMjYyNQo8ICMgQ09ORklHX0ZCX0FSTUNMQ0QgaXMgbm90IHNl
dAoyNjgwZDI2NTIKPCAjIENPTkZJR19GQl9YSUxJTlggaXMgbm90IHNldAoyODI4ZDI3OTkKPCAj
IENPTkZJR19TTkRfQVJNQUFDSSBpcyBub3Qgc2V0CjI4MzlkMjgwOQo8ICMgQ09ORklHX1NORF9T
T0NfQURJIGlzIG5vdCBzZXQKMzI4OWQzMjU4CjwgIyBDT05GSUdfTU1DX0FSTU1NQ0kgaXMgbm90
IHNldAozNDQwLDM0NDFkMzQwOAo8ICMgQ09ORklHX1JUQ19EUlZfUEwwMzAgaXMgbm90IHNldAo8
ICMgQ09ORklHX1JUQ19EUlZfUEwwMzEgaXMgbm90IHNldAozNDU4ZDM0MjQKPCAjIENPTkZJR19B
TUJBX1BMMDhYIGlzIG5vdCBzZXQKMzQ2NGQzNDI5CjwgIyBDT05GSUdfUEwzMzBfRE1BIGlzIG5v
dCBzZXQKMzQ2OWQzNDMzCjwgIyBDT05GSUdfWElMSU5YX1ZETUEgaXMgbm90IHNldAozNTYxZDM1
MjQKPCAjIENPTkZJR19DT01NT05fQ0xLX0FYSV9DTEtHRU4gaXMgbm90IHNldAozNTcxZDM1MzMK
PCBDT05GSUdfQ0FERU5DRV9UVENfVElNRVI9eQozNzA1ZDM2NjYKPCAjIENPTkZJR19ST09UX05G
UyBpcyBub3Qgc2V0CjM5MTIsMzkyMmMzODczCjwgQ09ORklHX0RFQlVHX0xMPXkKPCBDT05GSUdf
REVCVUdfWllOUV9VQVJUMD15CjwgIyBDT05GSUdfREVCVUdfWllOUV9VQVJUMSBpcyBub3Qgc2V0
CjwgIyBDT05GSUdfREVCVUdfSU1YNlFfVUFSVCBpcyBub3Qgc2V0CjwgIyBDT05GSUdfREVCVUdf
SU1YNlNMX1VBUlQgaXMgbm90IHNldAo8ICMgQ09ORklHX0RFQlVHX1NVTlhJX1VBUlQwIGlzIG5v
dCBzZXQKPCAjIENPTkZJR19ERUJVR19TVU5YSV9VQVJUMSBpcyBub3Qgc2V0CjwgIyBDT05GSUdf
REVCVUdfSUNFRENDIGlzIG5vdCBzZXQKPCAjIENPTkZJR19ERUJVR19TRU1JSE9TVElORyBpcyBu
b3Qgc2V0CjwgIyBDT05GSUdfREVCVUdfTExfVUFSVF84MjUwIGlzIG5vdCBzZXQKPCAjIENPTkZJ
R19ERUJVR19MTF9VQVJUX1BMMDFYIGlzIG5vdCBzZXQKLS0tCj4gIyBDT05GSUdfREVCVUdfTEwg
aXMgbm90IHNldAozOTI0YzM4NzUKPCBDT05GSUdfREVCVUdfTExfSU5DTFVERT0iZGVidWcvenlu
cS5TIgotLS0KPiBDT05GSUdfREVCVUdfTExfSU5DTFVERT0ibWFjaC9kZWJ1Zy1tYWNyby5TIgoz
OTI3ZDM4NzcKPCBDT05GSUdfREVCVUdfVU5DT01QUkVTUz15CjM5MjksMzkzMGQzODc4CjwgQ09O
RklHX0VBUkxZX1BSSU5USz15CjwgIyBDT05GSUdfT0NfRVRNIGlzIG5vdCBzZXQK

--_002_C4A61A5CA4AD2246942F4BA6F20ACB80435790DFALVAEXMB04alvau_--

