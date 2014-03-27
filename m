Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaC0Fuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:50:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56478 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaC0Fus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:50:48 -0400
Message-ID: <5333BC31.3030400@hitachi.com>
Date: Thu, 27 Mar 2014 14:50:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH -tip v8 10/26] kprobes/x86: Allow probe on some
 kprobe preparation functions
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115953.22766.53497.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324153556.2ae6b181@gandalf.local.home>
In-Reply-To: <20140324153556.2ae6b181@gandalf.local.home>
Content-Type: multipart/mixed;
 boundary="------------010104060400060805090704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010104060400060805090704
Content-Type: text/plain; charset=Shift_JIS
Content-Transfer-Encoding: 7bit

(2014/03/25 4:35), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:53 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> There is no need to prohibit probing on the functions
>> used in preparation phase. Those are safely probed because
>> those are not invoked from breakpoint/fault/debug handlers,
>> there is no chance to cause recursive exceptions.
>>
>> Following functions are now removed from the kprobes blacklist.
>>  can_boost
>>  can_probe
>>  can_optimize
>>  is_IF_modifier
>>  __copy_instruction
>>  copy_optimized_instructions
>>  arch_copy_kprobe
>>  arch_prepare_kprobe
>>  arch_arm_kprobe
>>  arch_disarm_kprobe
>>  arch_remove_kprobe
> 
> Is there any possibility that the arm and disarm could cause issues if
> we have a probe in the middle of setting it?
> 
> I guess not, but I just wanted to ask, as your test only tested the
> start of function and not the middle of it.

OK, I've tested it by attached script which adds probes on every address
of the target function and run a testcase(register/unregister other probes),
and found no problem. :)

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com




--------------010104060400060805090704
Content-Type: text/plain; charset=Shift_JIS;
 name="kprobes_test.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kprobes_test.sh"

IyEvYmluL2Jhc2gNClRBUkdFVFM9JDENCkZUUkFDRV9LUFJPQkVfRVZFTlQ9L3N5cy9rZXJu
ZWwvZGVidWcvdHJhY2luZy9rcHJvYmVfZXZlbnRzDQpGVFJBQ0VfS1BST0JFX1BST0ZJTEU9
L3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9rcHJvYmVfcHJvZmlsZQ0KRlRSQUNFX0VWRU5U
Uz0vc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2ZW50cw0KDQppZiBbICEgLWYgJFRBUkdF
VFMgXTsgdGhlbg0KICBlY2hvICJVc2FnZToga3Byb2JlX3Rlc3Quc2ggPFRhcmdldGZpbGU+
Ig0KICBleGl0IDENCmZpDQppZiBbIGBpZCAtdWAgLW5lIDAgXTsgdGhlbg0KICBlY2hvICJF
cnJvcjogVGhpcyBwcm9ncmFtIHJlcXVpcmVzIHJvb3QgcHJpdmlsZWdlIg0KICBleGl0IDIN
CmZpDQoNCmZ1bmN0aW9uIGdldF9zeW1ib2xfc2l6ZSgpIHsgI3N5bWJvbA0KZ3JlcCAkMSAt
dyAtbTEgLUExIC9wcm9jL2thbGxzeW1zIHxcDQogYXdrICdCRUdJTnsgcyA9IDAgfTsge3Ag
PSBzdHJ0b251bSgiMHgic3Vic3RyKCQxLDksOCkpOyBpZiAocyA9PSAwKSB7cyA9IHA7fSBl
bHNlIHsgcHJpbnQgcCAtIHN9fScNCn0NCg0KZnVuY3Rpb24gc2V0dXBfcHJvYmVzKCkgeyAj
c3ltYm9sDQpzaXplPWBnZXRfc3ltYm9sX3NpemUgJDFgDQppZiBbIC16ICIkc2l6ZSIgXTsg
dGhlbg0KICBlY2hvICJObyBzeW1ib2wgJDEgZm91bmQiDQogIHJldHVybiAxDQpmaQ0KaT0w
DQplcnI9MA0Kd2hpbGUgWyAkaSAtbHQgJHNpemUgXTsgZG8NCiAgKGVjaG8gcCAkMSskaSAg
Pj4gJEZUUkFDRV9LUFJPQkVfRVZFTlQpICY+IC9kZXYvbnVsbA0KICBbICQ/IC1lcSAwIF0g
fHwgZXJyPSQoKGVycisxKSkNCiAgaT0kKChpKzEpKQ0KZG9uZQ0KcHJvYmVkPWBleHByICRz
aXplIC0gJGVycmANCmVjaG8gIlNldHVwICRwcm9iZWQgcHJvYmVzIG9uICQxIg0KWyAkcHJv
YmVkIC1lcSAwIF0gJiYgcmV0dXJuIDENCnJldHVybiAwDQp9DQoNCmZ1bmN0aW9uIGVuYWJs
ZV9wcm9iZXMoKSB7DQplY2hvIDEgPiAkRlRSQUNFX0VWRU5UUy9rcHJvYmVzL2VuYWJsZQ0K
fQ0KDQpmdW5jdGlvbiBjbGVhcl9wcm9iZXMoKSB7DQplY2hvIDAgPiAkRlRSQUNFX0VWRU5U
Uy9rcHJvYmVzL2VuYWJsZQ0KZWNobyA+ICRGVFJBQ0VfS1BST0JFX0VWRU5UDQp9DQoNCmZ1
bmN0aW9uIHJ1bl90ZXN0KCkgew0KZWNobyBwOnRlc3QxIHZmc19zeW1saW5rID4+ICRGVFJB
Q0VfS1BST0JFX0VWRU5UDQplY2hvIHA6dGVzdDIgdmZzX3N5bWxpbmsrNSA+PiAkRlRSQUNF
X0tQUk9CRV9FVkVOVA0KZWNobyAxID4gJEZUUkFDRV9FVkVOVFMva3Byb2Jlcy90ZXN0MS9l
bmFibGUNCmVjaG8gMSA+ICRGVFJBQ0VfRVZFTlRTL2twcm9iZXMvdGVzdDIvZW5hYmxlDQpz
bGVlcCAxDQplY2hvIDAgPiAkRlRSQUNFX0VWRU5UUy9rcHJvYmVzL3Rlc3QxL2VuYWJsZQ0K
ZWNobyAwID4gJEZUUkFDRV9FVkVOVFMva3Byb2Jlcy90ZXN0Mi9lbmFibGUNCmVjaG8gLTp0
ZXN0MSA+PiAkRlRSQUNFX0tQUk9CRV9FVkVOVA0KZWNobyAtOnRlc3QyID4+ICRGVFJBQ0Vf
S1BST0JFX0VWRU5UDQp9DQoNCmZ1bmN0aW9uIHNhdmVfcHJvZmlsZSgpIHsgIyBzeW1ib2wN
CmNhdCAkRlRSQUNFX0tQUk9CRV9QUk9GSUxFID4gJHsxfS5wcm9maWxlDQp9DQoNCmZ1bmN0
aW9uIHRlc3Rfb24oKSB7ICMgc3ltYm9sDQpzZXR1cF9wcm9iZXMgJDENClsgJD8gLW5lIDAg
XSAmJiByZXR1cm4NCmVuYWJsZV9wcm9iZXMNCmVjaG8gIlByb2JlIEVuYWJsZWQiDQpydW5f
dGVzdA0KZWNobyAiVGVzdCBkb25lIG9uICQxIg0Kc2F2ZV9wcm9maWxlICQxDQpjbGVhcl9w
cm9iZXMNCn0NCg0KY2xlYXJfcHJvYmVzDQpjYXQgJFRBUkdFVFMgfCB3aGlsZSByZWFkIHN5
bTsgZG8NCiAgdGVzdF9vbiAkc3ltDQpkb25lDQoNCg==
--------------010104060400060805090704--
