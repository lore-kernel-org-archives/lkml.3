Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaJHPwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:52:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:47716 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaJHPwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,678,1406617200"; 
   d="scan'208";a="585435738"
Message-ID: <54355D56.8040908@intel.com>
Date: Wed, 08 Oct 2014 08:50:46 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bruce Allan <bruce.w.allan@intel.com>,
        John Griffin <john.griffin@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto, qat, use generic numa functions
References: <1412727129-14467-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1412727129-14467-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit,
On 10/07/2014 05:12 PM, Prarit Bhargava wrote:
> The method in which the qat code determines the numa node for memory
> allocations is a bit clunky.  On 2 socket, single node systems it is
> possible that adf_get_dev_node_id() returns node 1, even though node 1
> doesn't exist.
> 
> This code transitions the qat code to the generic numa functions.
> Changing adf_get_dev_node_id() to a simple call to dev_get_node() results
> in a change to the adf_accel_dev struct as well.

The problem with that is we don't want to use any valid numa node, but
the node we are connected to or we don't want to use the accelerator at
all. Otherwise, when the first valid numa node happens to be the remote
node the dma transactions we be slow and instead of accelerating we will
slow things down.
A patch that enforces this is on it's way.

