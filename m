Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3C0RH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:07:56 -0400
Received: from fe1.lbl.gov ([128.3.41.133]:22545 "EHLO fe1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3C0RHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:07:54 -0400
X-Ironport-SBRS: 2.2
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkCAGsmU1HRVdXGemdsb2JhbABDgzrAQncIFg4BAQkLDAgUBCSCHwEBBAF5BQsLCw0uIhIBBQEcBhOIDgYMoGqeFY8YB4NAA4h4jW+BH44GFimEThw
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="13008966"
MIME-Version: 1.0
In-Reply-To: <87a9ppgvbk.fsf@sejong.aot.lge.com>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
	<87a9ppgvbk.fsf@sejong.aot.lge.com>
Date: Wed, 27 Mar 2013 10:07:52 -0700
Message-ID: <CA+BNSkVVmnUJuas2DFOoF6OBfZpnK16S9u2pvawv+aELgNUBHw@mail.gmail.com>
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
From: Roberto Vitillo <ravitillo@lbl.gov>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:23 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Roberto,
>
> On Tue, 26 Mar 2013 12:14:49 -0700, Roberto Vitillo wrote:
>> The proposed patch adds the convert tool to perf which allows to convert a
>> perf.data file to a set of callgrind data files which can subsequently be
>> displayed with kcachegrind.
>>
>> Note that the code may trigger the following bug in libbfd:
>> http://sourceware.org/bugzilla/show_bug.cgi?id=15106
>
> Does it now support call graph too?  Great if so!

Yes it does.

> Anyway, I suggest that splitting patch to two - one for addr2line and
> another for actual 'convert' tool.

Ok

> I think we *can* use the tool
> without libbfd (but with external addr2line binary or even with no line
> number information).

Well, I could use the external addr2line binary but the tool will
become terribly slow. A warning message could notify the
user to recompile perf with libbfd to speed up the conversion.
