Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156Ab3IDHWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:22:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43866 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3IDHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:22:04 -0400
Message-ID: <5226DF97.3000704@hitachi.com>
Date: Wed, 04 Sep 2013 16:21:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora>
In-Reply-To: <20130903073655.4793.20013.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 16:36), Hemant Kumar wrote:
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 5f720dc..f2d17b7 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -197,6 +197,17 @@ struct symsrc {
>  #endif
>  };
>  
> +/* Note structure */
> +struct sdt_note {
> +	const char *name;
> +	const char *provider;
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} addr;
> +	struct sdt_note *next;
> +};

Hmm, could you use struct list_head for listing up the data?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


