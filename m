Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaKEGch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:32:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54869 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKEGcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:32:36 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: "acme\@kernel.org" <acme@kernel.org>,
        "jolsa\@kernel.org" <jolsa@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi\@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] perf tools: perf diff for different binaries
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
	<87tx2f5xpo.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701653813@SHSMSX103.ccr.corp.intel.com>
Date: Wed, 05 Nov 2014 15:32:34 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701653813@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Tue, 4 Nov 2014 17:07:43 +0000")
Message-ID: <87d292w41p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kan,

On Tue, 4 Nov 2014 17:07:43 +0000, Kan Liang wrote:
> Hi Namhyung,
>
>> >                             tchain_edit        [.] f1
>> >      0.14%        3.913444  tchain_edit        [.] f2
>> >     99.82%        1.005478  tchain_edit        [.] f3
>> 
>> Hmm.. I think it should be a default behavior for perf diff, otherwise -s
>> symbol is almost meaningless IMHO. 
>
> I think we need both instruction level and function level diff.
> For debugging scaling issue, I think we need to do deeper analysis for some
> cache or lock issue. The function level is too high granularity.  
>
> The new option can be used to debug scaling regression issue.
> If the binary/kernel is updated, it doesn't make sense to compare the
> symbol address, since it should be changed. So comparing the function
> should be more useful.
>
>
>> What about setting the
>> sort_sym.se_collapse in data_process() so that hists__match() can use
>> symbol names?
>
> Yes, we can set it if we only do function level diff. But I'd like to keep
> both. So I defined two sort keys.
> "symbol" means "symbol address executed at the time of sample "
> "symbol_name" means "name of function executed at the time of sample"

Hmm.. I don't think the symbol sort key provides the instruction level
diff that you want.  If it finds a symbol it just use the start address
of the symbol, not the exact address of the sample.  Am I missing
something?

Thanks,
Namhyung
