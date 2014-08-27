Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbaH0Kn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:43:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37966 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbaH0Kn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:43:26 -0400
Message-ID: <53FDB649.2070506@gmail.com>
Date: Wed, 27 Aug 2014 11:43:21 +0100
From: Iain Paton <ipaton0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
CC: Fabio Estevam <festevam@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int> <53F11FF6.8030303@gmail.com> <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com> <53F2E89B.80009@gmail.com> <53F5BE3D.5070209@gmail.com> <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com> <53F71D1B.8090004@gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB8043578CB2@ALVA-EXMB04.alv.autoliv.int>
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043578CB2@ALVA-EXMB04.alv.autoliv.int>
Content-Type: multipart/mixed;
 boundary="------------050800050206010208070809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050800050206010208070809
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On 27/08/14 07:32, Mattis Lorentzon wrote:
> Hi Iain, Russell and Fabio,
> 
>> The config is attached. Note that there's a lot of additional stuff enabled as
>> I'm aiming for a single general purpose kernel that covers i.MX6, AM3359,
>> Allwinner A10/A20 along with several versions of boards using those
>> particular SoCs.
>>
>> Same kernel binary on all the boards I've tried this on, only real differences
>> will be the devicetree and u-boot
> 
> Amazingly we have been able to run a complete nightly test on eight i.MX6
> boards without hickups using Iain's config! We had to modify it slightly to get
> it to boot, please find attached patch and Iain's patched config.

Interesting. We obviously have some differences in how we boot, my changes to 
your config to get it to boot basically amount to reverting the patch you attached 
and then enabling sata and mmc. So far I've been unable to get your config to fail.

I'm attaching the patch showing what I changed in case it sheds any light on 
what's going on, although I don't see why any of the changes make any difference.

My kernel command line is also fairly obvious with nothing I'd think is odd:
console=ttymxc1,115200n8 root=/dev/sda1 ro rootfstype=ext2 rootwait video= ahci-imx.hotplug=1

It would be good to know what makes my config work for you, I don't think I've 
done anything special with it.

Iain


--------------050800050206010208070809
Content-Type: text/plain; charset=UTF-8;
 name="config.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config.patch"

M2MzCjwgIyBMaW51eC9hcm0gMy4xNi4wIEtlcm5lbCBDb25maWd1cmF0aW9uCi0tLQo+ICMg
TGludXgvYXJtIDMuMTYuMC1yYzIgS2VybmVsIENvbmZpZ3VyYXRpb24KMzhjMzgKPCBDT05G
SUdfS0VSTkVMX0daSVA9eQotLS0KPiAjIENPTkZJR19LRVJORUxfR1pJUCBpcyBub3Qgc2V0
CjQxYzQxCjwgIyBDT05GSUdfS0VSTkVMX0xaTyBpcyBub3Qgc2V0Ci0tLQo+IENPTkZJR19L
RVJORUxfTFpPPXkKMjMzLDIzOWMyMzMKPCBDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEPXkK
PCAjIENPTkZJR19BQ09STl9QQVJUSVRJT04gaXMgbm90IHNldAo8ICMgQ09ORklHX0FJWF9Q
QVJUSVRJT04gaXMgbm90IHNldAo8ICMgQ09ORklHX09TRl9QQVJUSVRJT04gaXMgbm90IHNl
dAo8ICMgQ09ORklHX0FNSUdBX1BBUlRJVElPTiBpcyBub3Qgc2V0CjwgIyBDT05GSUdfQVRB
UklfUEFSVElUSU9OIGlzIG5vdCBzZXQKPCAjIENPTkZJR19NQUNfUEFSVElUSU9OIGlzIG5v
dCBzZXQKLS0tCj4gIyBDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEIGlzIG5vdCBzZXQKMjQx
LDI0OWQyMzQKPCAjIENPTkZJR19CU0RfRElTS0xBQkVMIGlzIG5vdCBzZXQKPCAjIENPTkZJ
R19NSU5JWF9TVUJQQVJUSVRJT04gaXMgbm90IHNldAo8ICMgQ09ORklHX1NPTEFSSVNfWDg2
X1BBUlRJVElPTiBpcyBub3Qgc2V0CjwgIyBDT05GSUdfVU5JWFdBUkVfRElTS0xBQkVMIGlz
IG5vdCBzZXQKPCAjIENPTkZJR19MRE1fUEFSVElUSU9OIGlzIG5vdCBzZXQKPCAjIENPTkZJ
R19TR0lfUEFSVElUSU9OIGlzIG5vdCBzZXQKPCAjIENPTkZJR19VTFRSSVhfUEFSVElUSU9O
IGlzIG5vdCBzZXQKPCAjIENPTkZJR19TVU5fUEFSVElUSU9OIGlzIG5vdCBzZXQKPCAjIENP
TkZJR19LQVJNQV9QQVJUSVRJT04gaXMgbm90IHNldAoyNTEsMjUyZDIzNQo8ICMgQ09ORklH
X1NZU1Y2OF9QQVJUSVRJT04gaXMgbm90IHNldAo8ICMgQ09ORklHX0NNRExJTkVfUEFSVElU
SU9OIGlzIG5vdCBzZXQKMjY1LDI2NmQyNDcKPCBDT05GSUdfQVJDSF9TVVBQT1JUU19BVE9N
SUNfUk1XPXkKPCBDT05GSUdfUldTRU1fU1BJTl9PTl9PV05FUj15CjUzMyw1MzRjNTE0LDUy
MQo8ICMgQ09ORklHX0FSTV9BUFBFTkRFRF9EVEIgaXMgbm90IHNldAo8IENPTkZJR19DTURM
SU5FPSIiCi0tLQo+IENPTkZJR19BUk1fQVBQRU5ERURfRFRCPXkKPiBDT05GSUdfQVJNX0FU
QUdfRFRCX0NPTVBBVD15Cj4gQ09ORklHX0FSTV9BVEFHX0RUQl9DT01QQVRfQ01ETElORV9G
Uk9NX0JPT1RMT0FERVI9eQo+ICMgQ09ORklHX0FSTV9BVEFHX0RUQl9DT01QQVRfQ01ETElO
RV9FWFRFTkQgaXMgbm90IHNldAo+IENPTkZJR19DTURMSU5FPSJfX19jb25zb2xlPXR0eW14
YzAsMTE1MjAwIF9fX2RlYnVnIF9fX0xPR0xFVkVMPTggX19faW5pdHJkPTB4MTE4MDAwNDAs
MTIzODM0OTEgX19fZHluZGJnPVwiZmlsZSAqICtwXCIiCj4gQ09ORklHX0NNRExJTkVfRlJP
TV9CT09UTE9BREVSPXkKPiAjIENPTkZJR19DTURMSU5FX0VYVEVORCBpcyBub3Qgc2V0Cj4g
IyBDT05GSUdfQ01ETElORV9GT1JDRSBpcyBub3Qgc2V0CjU5MWM1NzgKPCAjIENPTkZJR19Q
TV9URVNUX1NVU1BFTkQgaXMgbm90IHNldAotLS0KPiBDT05GSUdfUE1fVEVTVF9TVVNQRU5E
PXkKOTE5ZDkwNQo8IENPTkZJR19BUkNIX01JR0hUX0hBVkVfUENfUEFSUE9SVD15CjkyMGE5
MDcKPiBDT05GSUdfQVJDSF9NSUdIVF9IQVZFX1BDX1BBUlBPUlQ9eQoxMDQ1LDEwNTljMTAz
Mgo8IENPTkZJR19BVEE9eQo8ICMgQ09ORklHX0FUQV9OT05TVEFOREFSRCBpcyBub3Qgc2V0
CjwgQ09ORklHX0FUQV9WRVJCT1NFX0VSUk9SPXkKPCBDT05GSUdfU0FUQV9QTVA9eQo8IAo8
ICMKPCAjIENvbnRyb2xsZXJzIHdpdGggbm9uLVNGRiBuYXRpdmUgaW50ZXJmYWNlCjwgIwo8
IENPTkZJR19TQVRBX0FIQ0k9eQo8IENPTkZJR19TQVRBX0FIQ0lfUExBVEZPUk09eQo8IENP
TkZJR19BSENJX0lNWD15CjwgIyBDT05GSUdfU0FUQV9JTklDMTYyWCBpcyBub3Qgc2V0Cjwg
IyBDT05GSUdfU0FUQV9BQ0FSRF9BSENJIGlzIG5vdCBzZXQKPCAjIENPTkZJR19TQVRBX1NJ
TDI0IGlzIG5vdCBzZXQKPCAjIENPTkZJR19BVEFfU0ZGIGlzIG5vdCBzZXQKLS0tCj4gIyBD
T05GSUdfQVRBIGlzIG5vdCBzZXQKMTc4NiwxODE1YzE3NTkKPCBDT05GSUdfTU1DPXkKPCAj
IENPTkZJR19NTUNfREVCVUcgaXMgbm90IHNldAo8ICMgQ09ORklHX01NQ19DTEtHQVRFIGlz
IG5vdCBzZXQKPCAKPCAjCjwgIyBNTUMvU0QvU0RJTyBDYXJkIERyaXZlcnMKPCAjCjwgQ09O
RklHX01NQ19CTE9DSz15CjwgQ09ORklHX01NQ19CTE9DS19NSU5PUlM9OAo8IENPTkZJR19N
TUNfQkxPQ0tfQk9VTkNFPXkKPCAjIENPTkZJR19TRElPX1VBUlQgaXMgbm90IHNldAo8ICMg
Q09ORklHX01NQ19URVNUIGlzIG5vdCBzZXQKPCAKPCAjCjwgIyBNTUMvU0QvU0RJTyBIb3N0
IENvbnRyb2xsZXIgRHJpdmVycwo8ICMKPCBDT05GSUdfTU1DX1NESENJPXkKPCBDT05GSUdf
TU1DX1NESENJX0lPX0FDQ0VTU09SUz15CjwgIyBDT05GSUdfTU1DX1NESENJX1BDSSBpcyBu
b3Qgc2V0CjwgQ09ORklHX01NQ19TREhDSV9QTFRGTT15CjwgIyBDT05GSUdfTU1DX1NESENJ
X09GX0FSQVNBTiBpcyBub3Qgc2V0CjwgQ09ORklHX01NQ19TREhDSV9FU0RIQ19JTVg9eQo8
ICMgQ09ORklHX01NQ19TREhDSV9QWEFWMyBpcyBub3Qgc2V0CjwgIyBDT05GSUdfTU1DX1NE
SENJX1BYQVYyIGlzIG5vdCBzZXQKPCAjIENPTkZJR19NTUNfTVhDIGlzIG5vdCBzZXQKPCAj
IENPTkZJR19NTUNfVElGTV9TRCBpcyBub3Qgc2V0CjwgIyBDT05GSUdfTU1DX0NCNzEwIGlz
IG5vdCBzZXQKPCAjIENPTkZJR19NTUNfVklBX1NETU1DIGlzIG5vdCBzZXQKPCAjIENPTkZJ
R19NTUNfRFcgaXMgbm90IHNldAo8ICMgQ09ORklHX01NQ19VU0RISTZST0wwIGlzIG5vdCBz
ZXQKLS0tCj4gIyBDT05GSUdfTU1DIGlzIG5vdCBzZXQKMTk2OGQxOTExCjwgIyBDT05GSUdf
V0lNQVhfR0RNNzJYWCBpcyBub3Qgc2V0Cg==
--------------050800050206010208070809--
