Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDQOFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:05:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:12576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaDQOFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,879,1389772800"; 
   d="scan'208";a="494779166"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
CC: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "qmewlo@gmail.com" <qmewlo@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Thread-Topic: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Thread-Index: AQHPWiOw9sB2fMRRykSwrH6SNaHatJsWC2AAgAAELgD//8cJcA==
Date: Thu, 17 Apr 2014 14:03:34 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
 <20140417100944.GG11096@twins.programming.kicks-ass.net>
 <20140417102442.GA8215@pd.tnic>
In-Reply-To: <20140417102442.GA8215@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: multipart/mixed;
	boundary="_002_3908561D78D1C84285E8C5FCA982C28F31E2A1D3ORSMSX106amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_3908561D78D1C84285E8C5FCA982C28F31E2A1D3ORSMSX106amrcor_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBIb2h1bSwgX19yYXdfc3Bpbl9sb2NrX2lycXNhdmUgZG9lcyBwcmVlbXB0X2Rpc2FibGUoKS4g
QW5kDQo+IG1hY2hpbmVfY2hlY2tfcG9sbCBzaG91bGQgYmUgcnVubmluZyBpbiBpcnEgY29udGV4
dCBzbyB3aHkgd291bGQgdGhlDQo+IG9yaWdpbmFsIGlzc3VlIGhhcHBlbj8NCj4NCj4+IGtlcm5l
bDogWyAgICA3LjM0MTA4NV0gQlVHOiB1c2luZyBfX3RoaXNfY3B1X3dyaXRlKCkgaW4gcHJlZW1w
dGlibGUgWzAwMDAwMDAwXSBjb2RlOiBtb2Rwcm9iZS81NDYNCj4NCj4gVW5mb3J0dW5hdGVseSwg
SSBoYXZlIG9ubHkgb25lIGxpbmUgaW4gYSBtYWlsIENDZWQgdG8gbWUuDQo+DQo+IENvbG9yIG1l
IGNvbmZ1c2VkLg0KDQpJcyB0aGlzIGp1c3QgdGhlIG1pc3NpbmcgcHV0X2NwdSgpIHRoYXQgQ2hl
biBHb25nIGFscmVhZHkgc2VudCBhIHBhdGNoIGZvcj8NCg0KU2VlIGF0dGFjaGVkDQoNCi1Ub255
DQo=

--_002_3908561D78D1C84285E8C5FCA982C28F31E2A1D3ORSMSX106amrcor_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 17 Apr 2014 14:03:32 GMT";
	modification-date="Thu, 17 Apr 2014 14:03:32 GMT"

Received: from fmsmga002.fm.intel.com (10.253.24.26) by
 ORSMSX105-2.jf.intel.com (10.22.225.145) with Microsoft SMTP Server id
 14.3.123.3; Wed, 16 Apr 2014 23:54:09 -0700
Received: from gchen-sby.bj.intel.com (HELO localhost) ([10.238.158.82])  by
 fmsmga002.fm.intel.com with ESMTP; 16 Apr 2014 23:53:56 -0700
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"m.chehab@samsung.com" <m.chehab@samsung.com>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "arozansk@redhat.com" <arozansk@redhat.com>,
	"Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 1/2 v2] x86, MCE: Fix a bug in CMCI handler
Thread-Topic: [PATCH 1/2 v2] x86, MCE: Fix a bug in CMCI handler
Thread-Index: AQHPWgnV3hN7Xfr8eUyImTNDowSD+g==
Date: Thu, 17 Apr 2014 06:28:35 +0000
Message-ID: <1397716119-6164-2-git-send-email-gong.chen@linux.intel.com>
References: <1397716119-6164-1-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1397716119-6164-1-git-send-email-gong.chen@linux.intel.com>
Content-Language: en-US
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: ORSMSX105.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.97,877,1389772800";
    d="scan'208";a="522080347"
x-extloop1: 1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

This bug is introduced by me in commit 27f6c573e0. I forget
to execute put_cpu_var operation after get_cpu_var. Fix it
via this_cpu_write instead of get_cpu_var.

v2 -> v1: Separate cleanup from bug fix.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/=
mce.c
index eeee23f..68317c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -598,7 +598,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks=
_t *b)
 {
        struct mce m;
        int i;
-       unsigned long *v;

        this_cpu_inc(mce_poll_count);

@@ -618,8 +617,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks=
_t *b)
                if (!(m.status & MCI_STATUS_VAL))
                        continue;

-               v =3D &get_cpu_var(mce_polled_error);
-               set_bit(0, v);
+               this_cpu_write(mce_polled_error, 1);
                /*
                 * Uncorrected or signalled events are handled by the excep=
tion
                 * handler when it is enabled, so don't process those here.
--
1.9.0


--_002_3908561D78D1C84285E8C5FCA982C28F31E2A1D3ORSMSX106amrcor_--
