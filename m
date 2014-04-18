Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDRETk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:19:40 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57942 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaDRETh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:19:37 -0400
Message-ID: <5350A7D0.8070603@redhat.com>
Date: Fri, 18 Apr 2014 00:19:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: vmx: speed up emulation of invalid guest
 state
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com> <1395919838-18466-2-git-send-email-pbonzini@redhat.com> <20140416225258.GA19597@amt.cnet>
In-Reply-To: <20140416225258.GA19597@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/04/2014 18:52, Marcelo Tosatti ha scritto:
> How about handling VM-entry error due to invalid state with
>
> vmx->emulation_required = true;
> continue to main vcpu loop;

What would reset it to false though?  None of the places that call 
emulation_required() is a hot path right now, and this patch doesn't add 
any.

Paolo
