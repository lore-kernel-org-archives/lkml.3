Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689Ab3D3Npf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:45:35 -0400
Received: from gecko.sbs.de ([194.138.37.40]:25771 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460Ab3D3Npe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:45:34 -0400
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: X86 fpu registers in a signal handler's ucontext
Thread-Topic: X86 fpu registers in a signal handler's ucontext
Thread-Index: AQHORZXVqvz3Ty+ARUuGAGM8sG/3EJjusiaw
Date: Tue, 30 Apr 2013 13:45:09 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DE208@DEFTHW99EK1MSX.ww902.siemens.net>
References: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
	<m2a9ohusmp.fsf@firstfloor.org>
	<6D83E89737156549AEA25EF9ED712C5DE0A9@DEFTHW99EK1MSX.ww902.siemens.net>
 <20863.43739.999287.287981@pilspetsen.it.uu.se>
In-Reply-To: <20863.43739.999287.287981@pilspetsen.it.uu.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [139.22.70.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:
> Write to the fpstate ->mxcsr and ->swd fields in the sigaction handler's uc_mcontext.

To me, "sigaction handler's uc_mcontext" sounds like userspace, which really confuses me:
Even in most recent glibc-2.17, uc_mcontext is of type mcontext_t, which us defined as:

typedef struct {
  gregset_t gregs;
  fpregset_t fpregs;
} mcontext_t;

typedef struct fpregset {
    union {
	struct fpchip_state {
	    int state[27];
	    int status;
	} fpchip_state;
	struct fp_emul_space {
	    char fp_emul[246];
	    char fp_epad[2];
	} fp_emul_space;
	int f_fpregs[62];
    } fp_reg_set;
    long int f_wregs[33];
} fpregset_t;

So there is no fpstate whatsoever.

However, these elements seem to be available in the uc_mcontext definition of the
kernel, but I can't have a sigaction handler there, can I? Then, how does the
kernel's uc_mcontext definition help me in my (userspace) signal handler?
