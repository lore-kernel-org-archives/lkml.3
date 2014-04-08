Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaDHOGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:06:45 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:54597 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbaDHOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:06:43 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 10:06:42 EDT
MIME-Version: 1.0
In-Reply-To: <877g71jdl8.fsf@tassilo.jf.intel.com>
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
	<877g71jdl8.fsf@tassilo.jf.intel.com>
Date: Tue, 8 Apr 2014 22:00:13 +0800
Message-ID: <CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
From: Ling Ma <ling.ma.program@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, neleai@seznam.cz,
        linux-kernel@vger.kernel.org, Ling Ma <ling.ml@alibaba-inc.com>
Content-Type: multipart/mixed; boundary=089e0153819a61272b04f6886708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0153819a61272b04f6886708
Content-Type: text/plain; charset=ISO-8859-1

Andi,

The below is compared result on older machine(cpu info is attached):
That shows new code get better performance up to 1.6x.

Bytes: ORG_TIME: NEW_TIME: ORG vs NEW:
7       0.87    0.76    1.14
16      0.99    0.68    1.45
18      1.07    0.77    1.38
21      1.09    0.78    1.39
25      1.11    0.77    1.44
30      1.12    0.73    1.53
36      1.15    0.75    1.53
38      1.12    0.75    1.49
62      1.18    0.77    1.53
75      1.25    0.79    1.58
85      1.28    0.80    1.60
120     1.33    0.82    1.62
193     1.45    0.88    1.64
245     1.48    0.96    1.54
256     1.45    0.90    1.61
356     1.61    1.02    1.57
601     1.78    1.22    1.45
958     2.04    1.47    1.38
1024    2.07    1.48    1.39
2048    2.80    2.21    1.26

Thanks
Ling

2014-04-08 0:42 GMT+08:00, Andi Kleen <andi@firstfloor.org>:
> ling.ma.program@gmail.com writes:
>
>> From: Ling Ma <ling.ml@alibaba-inc.com>
>>
>> In this patch we manage to reduce miss branch prediction by
>> avoiding using branch instructions and force destination to be aligned
>> with general 64bit instruction.
>> Below compared results shows we improve performance up to 1.8x
>> (We modified test suit from Ondra, send after this patch)
>
> You didn't specify the CPU?
>
> I assume it's some Atom, as nothing else uses these open coded functions
> anymore?
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
>

--089e0153819a61272b04f6886708
Content-Type: text/plain; charset=US-ASCII; name=cpu-info
Content-Disposition: attachment; filename=cpu-info
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9k
ZWwJCTogMjMKbW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQx
MCAgQCAyLjMzR0h6CnN0ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXpl
CTogNjE0NCBLQgpwaHlzaWNhbCBpZAk6IDAKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMApjcHUg
Y29yZXMJOiA0CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEz
CndwCQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFw
aWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBm
eHNyIHNzZSBzc2UyIHNzIGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25p
dG9yIGRzX2NwbCB2bXggZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTgu
MjcKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6
IDM4IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJv
Y2Vzc29yCTogMQp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJ
CTogMjMKbW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAg
QCAyLjMzR0h6CnN0ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTog
NjE0NCBLQgpwaHlzaWNhbCBpZAk6IDEKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMApjcHUgY29y
ZXMJOiA0CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndw
CQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMg
c2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNy
IHNzZSBzc2UyIHNzIGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9y
IGRzX2NwbCB2bXggZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTUuMDMK
Y2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4
IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vz
c29yCTogMgp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTog
MjMKbW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAy
LjMzR0h6CnN0ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0
NCBLQgpwaHlzaWNhbCBpZAk6IDAKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMgpjcHUgY29yZXMJ
OiA0CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6
IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2Vw
IG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNz
ZSBzc2UyIHNzIGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRz
X2NwbCB2bXggZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTUuMDAKY2xm
bHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJp
dHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29y
CTogMwp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMjMK
bW9kZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAyLjMz
R0h6CnN0ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0NCBL
QgpwaHlzaWNhbCBpZAk6IDEKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMgpjcHUgY29yZXMJOiA0
CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHll
cwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10
cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBz
c2UyIHNzIGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2Nw
bCB2bXggZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTQuNTMKY2xmbHVz
aCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJpdHMg
cGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTog
NAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMjMKbW9k
ZWwgbmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAyLjMzR0h6
CnN0ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0NCBLQgpw
aHlzaWNhbCBpZAk6IDAKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMQpjcHUgY29yZXMJOiA0CmZw
dQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpm
bGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIg
cGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2Uy
IHNzIGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2
bXggZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTUuMDIKY2xmbHVzaCBz
aXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJpdHMgcGh5
c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNQp2
ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMjMKbW9kZWwg
bmFtZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAyLjMzR0h6CnN0
ZXBwaW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0NCBLQgpwaHlz
aWNhbCBpZAk6IDEKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMQpjcHUgY29yZXMJOiA0CmZwdQkJ
OiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFn
cwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdl
IG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNz
IGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2bXgg
ZXN0IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTQuOTcKY2xmbHVzaCBzaXpl
CTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJpdHMgcGh5c2lj
YWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNgp2ZW5k
b3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMjMKbW9kZWwgbmFt
ZQk6IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAyLjMzR0h6CnN0ZXBw
aW5nCTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0NCBLQgpwaHlzaWNh
bCBpZAk6IDAKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMwpjcHUgY29yZXMJOiA0CmZwdQkJOiB5
ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJ
OiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1j
YSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0
IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2bXggZXN0
IHRtMiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTUuMDAKY2xmbHVzaCBzaXplCTog
NjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJpdHMgcGh5c2ljYWws
IDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNwp2ZW5kb3Jf
aWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogMjMKbW9kZWwgbmFtZQk6
IEludGVsKFIpIFhlb24oUikgQ1BVICAgICAgICAgICBFNTQxMCAgQCAyLjMzR0h6CnN0ZXBwaW5n
CTogMTAKY3B1IE1IegkJOiAyMzI3LjUwNgpjYWNoZSBzaXplCTogNjE0NCBLQgpwaHlzaWNhbCBp
ZAk6IDEKc2libGluZ3MJOiA0CmNvcmUgaWQJCTogMwpjcHUgY29yZXMJOiA0CmZwdQkJOiB5ZXMK
ZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJOiBm
cHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBj
bW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRt
IHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2bXggZXN0IHRt
MiBjeDE2IHh0cHIgbGFoZl9sbQpib2dvbWlwcwk6IDQ2NTUuMDEKY2xmbHVzaCBzaXplCTogNjQK
Y2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM4IGJpdHMgcGh5c2ljYWwsIDQ4
IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoK
--089e0153819a61272b04f6886708--
