Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3ILTWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:22:15 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35411 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3ILTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:22:14 -0400
Message-ID: <5232145B.7070009@linux.vnet.ibm.com>
Date: Fri, 13 Sep 2013 00:52:03 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "seiji.aguchi@hds.com" <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Subject: Re: [PATCH v2] pstore: Adjust buffer size for compression for smaller
 registered buffers
References: <20130912064832.15340.52422.stgit@aruna-ThinkPad-T420> <3908561D78D1C84285E8C5FCA982C28F31CF6AB8@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CF6AB8@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091219-8878-0000-0000-000008D0EF39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 September 2013 11:13 PM, Luck, Tony wrote:
> +	default:
> +		cmpr = 60;
> +		break;
> +	}
>
> Is this the right "default"?  It may be a good choice for a backend with a really
> tiny buffer (1 ... 999).  But less good for a (theoretical) backend with a larger
> buffer (10001 ... infinity and beyond).  Which are you trying to catch here?

Trying to catch lower buffers and also tried till 23k ( 10k * 100/45) of text with a
sample crash logit achieved a good compression of 25%. Since the upper limit is 
not known
and compression behavior is not tested above 10k chose to keep a higher default 
of 60.

> -Tony
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

