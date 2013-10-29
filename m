Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3J2Tyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:54:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35328 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3J2Tyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <1383058315.6521.3158.camel@bordewijk.wildebeest.org>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	<20131023050502.1886.15779.stgit@hemant-fedora>
	<CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
	<526E4940.8000608@hitachi.com>
	<526E5BA5.7050103@iki.fi>
	<20131028141152.GA1040@linux.vnet.ibm.com>
	<526E72EC.9060400@iki.fi>
	<20131028173152.GB1040@linux.vnet.ibm.com>
	<526EA366.4020204@iki.fi>
	<526F2949.5000208@hitachi.com>
	<1383058315.6521.3158.camel@bordewijk.wildebeest.org>
Date: Tue, 29 Oct 2013 21:54:41 +0200
X-Google-Sender-Auth: dSgneP1xwt5YE8X_VGMdnA6RlF0
Message-ID: <CAOJsxLFX3zHT5tc9JgSteCqASEMJbCuhp9DhL_Afma=8ygTjWg@mail.gmail.com>
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
From: Pekka Enberg <penberg@kernel.org>
To: Mark Wielaard <mjw@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        Anton Arapov <anton@redhat.com>, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 4:51 PM, Mark Wielaard <mjw@redhat.com> wrote:
> A nice user case to think about when designing this interface might be
> the java hotspot jvm (libjvm.so). It has SDT markers with the same name
> that might occur at multiple addresses depending on code path taken or
> compiler optimization. And there are multiple libjvm.so variants
> depending on whether the user uses the client or server VM. And users
> often have multiple major versions installed (both 1.6 and 1.7 are
> currently being shipped by some distros and can be installed in
> parallel).
>
> Normally a user that wants to monitor say the hotspot:gc__begin SDT
> probe wants to see that probe in whatever code path it happens and in
> whatever libjvm.so happens to be running (client or server and 1.6 or
> 1.7 version). But might still want to be able to specify a specific
> variant.

Agreed, it's an excellent use case.
