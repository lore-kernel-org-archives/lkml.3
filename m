Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaDOAEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:04:52 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51849 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaDOAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:04:50 -0400
Date: Mon, 14 Apr 2014 18:04:46 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ryan Desfosses <ryan@desfo.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: moved EXPORT_SYMBOL so that it immediately followed
 its function/variable
Message-ID: <20140415000446.GD16058@google.com>
References: <1396908083-5580-1-git-send-email-ryan@desfo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396908083-5580-1-git-send-email-ryan@desfo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 06:01:23PM -0400, Ryan Desfosses wrote:
> change made to resolve following checkpatch message:
>         WARNING: EXPORT_SYMBOL(foo); should immediately follow
>                 its function/aariable
> branch: Linux 3.14
> 
> Signed-off-by: Ryan Desfosses <ryan@desfo.org>
> ---
>  drivers/pci/pci.c | 71 ++++++++++++++++++++++++++++---------------------------

I don't mind doing this, but if we're going to make changes like this,
let's do them for the whole drivers/pci hierarchy in one patch, so we can
get them all done at once.

A couple minor nits below.

>  1 file changed, 36 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index fdbc294..7852f70 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -226,6 +226,7 @@ int pci_find_capability(struct pci_dev *dev, int cap)
>  
>  	return pos;
>  }
> +EXPORT_SYMBOL(pci_find_capability);
>  
>  /**
>   * pci_bus_find_capability - query for devices' capabilities
> @@ -253,6 +254,7 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
>  
>  	return pos;
>  }
> +EXPORT_SYMBOL(pci_bus_find_capability);
>  
>  /**
>   * pci_find_next_ext_capability - Find an extended capability
> @@ -429,6 +431,7 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
>  	}
>  	return best;
>  }
> +EXPORT_SYMBOL(pci_find_parent_resource);
>  
>  /**
>   * pci_wait_for_pending - wait for @mask bit(s) to clear in status word @pos
> @@ -493,6 +496,7 @@ static inline int platform_pci_set_power_state(struct pci_dev *dev,
>  {
>  	return pci_platform_pm ? pci_platform_pm->set_state(dev, t) : -ENOSYS;
>  }
> +EXPORT_SYMBOL(pci_set_power_state);

Oops, this went to the wrong function.

>  static inline pci_power_t platform_pci_choose_state(struct pci_dev *dev)
>  {
> @@ -1010,6 +1014,7 @@ pci_save_state(struct pci_dev *dev)
>  		return i;
>  	return 0;
>  }
> +EXPORT_SYMBOL(pci_save_state);
>  
>  static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
>  				     u32 saved_val, int retry)
> @@ -1080,6 +1085,7 @@ void pci_restore_state(struct pci_dev *dev)
>  
>  	dev->state_saved = false;
>  }
> +EXPORT_SYMBOL(pci_restore_state);
>  
>  struct pci_saved_state {
>  	u32 config_space[16];
> @@ -1219,6 +1225,7 @@ int pci_reenable_device(struct pci_dev *dev)
>  		return do_pci_enable_device(dev, (1 << PCI_NUM_RESOURCES) - 1);
>  	return 0;
>  }
> +EXPORT_SYMBOL(pci_reenable_device);
>  
>  static void pci_enable_bridge(struct pci_dev *dev)
>  {
> @@ -1293,6 +1300,7 @@ int pci_enable_device_io(struct pci_dev *dev)
>  {
>  	return pci_enable_device_flags(dev, IORESOURCE_IO);
>  }
> +EXPORT_SYMBOL(pci_enable_device_io);
>  
>  /**
>   * pci_enable_device_mem - Initialize a device for use with Memory space
> @@ -1306,6 +1314,7 @@ int pci_enable_device_mem(struct pci_dev *dev)
>  {
>  	return pci_enable_device_flags(dev, IORESOURCE_MEM);
>  }
> +EXPORT_SYMBOL(pci_enable_device_mem);
>  
>  /**
>   * pci_enable_device - Initialize device before it's used by a driver.
> @@ -1322,6 +1331,7 @@ int pci_enable_device(struct pci_dev *dev)
>  {
>  	return pci_enable_device_flags(dev, IORESOURCE_MEM | IORESOURCE_IO);
>  }
> +EXPORT_SYMBOL(pci_enable_device);
>  
>  /*
>   * Managed PCI resources.  This manages device on/off, intx/msi/msix
> @@ -1404,6 +1414,7 @@ int pcim_enable_device(struct pci_dev *pdev)
>  	}
>  	return rc;
>  }
> +EXPORT_SYMBOL(pcim_enable_device);
>  
>  /**
>   * pcim_pin_device - Pin managed PCI device
> @@ -1422,6 +1433,7 @@ void pcim_pin_device(struct pci_dev *pdev)
>  	if (dr)
>  		dr->pinned = 1;
>  }
> +EXPORT_SYMBOL(pcim_pin_device);
>  
>  /*
>   * pcibios_add_device - provide arch specific hooks when adding device dev
> @@ -1511,6 +1523,7 @@ pci_disable_device(struct pci_dev *dev)
>  
>  	dev->is_busmaster = 0;
>  }
> +EXPORT_SYMBOL(pci_disable_device);
>  
>  /**
>   * pcibios_set_pcie_reset_state - set reset state for device dev
> @@ -1539,6 +1552,7 @@ int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state)
>  {
>  	return pcibios_set_pcie_reset_state(dev, state);
>  }
> +EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
>  
>  /**
>   * pci_check_pme_status - Check if given device has generated PME.
> @@ -1618,6 +1632,7 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
>  
>  	return !!(dev->pme_support & (1 << state));
>  }
> +EXPORT_SYMBOL(pci_pme_capable);
>  
>  static void pci_pme_list_scan(struct work_struct *work)
>  {
> @@ -1724,6 +1739,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
>  
>  	dev_dbg(&dev->dev, "PME# %s\n", enable ? "enabled" : "disabled");
>  }
> +EXPORT_SYMBOL(pci_pme_active);
>  
>  /**
>   * __pci_enable_wake - enable PCI device as wakeup event source
> @@ -1809,6 +1825,7 @@ int pci_wake_from_d3(struct pci_dev *dev, bool enable)
>  			pci_enable_wake(dev, PCI_D3cold, enable) :
>  			pci_enable_wake(dev, PCI_D3hot, enable);
>  }
> +EXPORT_SYMBOL(pci_wake_from_d3);
>  
>  /**
>   * pci_target_state - find an appropriate low power state for a given PCI dev
> @@ -1887,6 +1904,7 @@ int pci_prepare_to_sleep(struct pci_dev *dev)
>  
>  	return error;
>  }
> +EXPORT_SYMBOL(pci_prepare_to_sleep);
>  
>  /**
>   * pci_back_from_sleep - turn PCI device on during system-wide transition into working state
> @@ -1899,6 +1917,7 @@ int pci_back_from_sleep(struct pci_dev *dev)
>  	pci_enable_wake(dev, PCI_D0, false);
>  	return pci_set_power_state(dev, PCI_D0);
>  }
> +EXPORT_SYMBOL(pci_back_from_sleep);
>  
>  /**
>   * pci_finish_runtime_suspend - Carry out PCI-specific part of runtime suspend.
> @@ -2443,6 +2462,7 @@ void pci_release_region(struct pci_dev *pdev, int bar)
>  	if (dr)
>  		dr->region_mask &= ~(1 << bar);
>  }
> +EXPORT_SYMBOL(pci_release_region);
>  
>  /**
>   *	__pci_request_region - Reserved PCI I/O and memory resource
> @@ -2513,6 +2533,7 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
>  {
>  	return __pci_request_region(pdev, bar, res_name, 0);
>  }
> +EXPORT_SYMBOL(pci_request_region);
>  
>  /**
>   *	pci_request_region_exclusive - Reserved PCI I/O and memory resource
> @@ -2536,6 +2557,8 @@ int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_
>  {
>  	return __pci_request_region(pdev, bar, res_name, IORESOURCE_EXCLUSIVE);
>  }
> +EXPORT_SYMBOL(pci_request_region_exclusive);
> +
>  /**
>   * pci_release_selected_regions - Release selected PCI I/O and memory resources
>   * @pdev: PCI device whose resources were previously reserved
> @@ -2552,6 +2575,7 @@ void pci_release_selected_regions(struct pci_dev *pdev, int bars)
>  		if (bars & (1 << i))
>  			pci_release_region(pdev, i);
>  }
> +EXPORT_SYMBOL(pci_release_selected_regions);
>  
>  static int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
>  				 const char *res_name, int excl)
> @@ -2584,6 +2608,7 @@ int pci_request_selected_regions(struct pci_dev *pdev, int bars,
>  {
>  	return __pci_request_selected_regions(pdev, bars, res_name, 0);
>  }
> +EXPORT_SYMBOL(pci_request_selected_regions);
>  
>  int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
>  				 int bars, const char *res_name)
> @@ -2591,6 +2616,7 @@ int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
>  	return __pci_request_selected_regions(pdev, bars, res_name,
>  			IORESOURCE_EXCLUSIVE);
>  }
> +EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
>  
>  /**
>   *	pci_release_regions - Release reserved PCI I/O and memory resources
> @@ -2605,6 +2631,7 @@ void pci_release_regions(struct pci_dev *pdev)
>  {
>  	pci_release_selected_regions(pdev, (1 << 6) - 1);
>  }
> +EXPORT_SYMBOL(pci_release_regions);
>  
>  /**
>   *	pci_request_regions - Reserved PCI I/O and memory resources
> @@ -2623,6 +2650,7 @@ int pci_request_regions(struct pci_dev *pdev, const char *res_name)
>  {
>  	return pci_request_selected_regions(pdev, ((1 << 6) - 1), res_name);
>  }
> +EXPORT_SYMBOL(pci_request_regions);
>  
>  /**
>   *	pci_request_regions_exclusive - Reserved PCI I/O and memory resources
> @@ -2645,6 +2673,7 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
>  	return pci_request_selected_regions_exclusive(pdev,
>  					((1 << 6) - 1), res_name);
>  }
> +EXPORT_SYMBOL(pci_request_regions_exclusive);
>  
>  static void __pci_set_master(struct pci_dev *dev, bool enable)
>  {
> @@ -2714,6 +2743,7 @@ void pci_set_master(struct pci_dev *dev)
>  	__pci_set_master(dev, true);
>  	pcibios_set_master(dev);
>  }
> +EXPORT_SYMBOL(pci_set_master);
>  
>  /**
>   * pci_clear_master - disables bus-mastering for device dev
> @@ -2723,6 +2753,7 @@ void pci_clear_master(struct pci_dev *dev)
>  {
>  	__pci_set_master(dev, false);
>  }
> +EXPORT_SYMBOL(pci_clear_master);
>  
>  /**
>   * pci_set_cacheline_size - ensure the CACHE_LINE_SIZE register is programmed
> @@ -2767,6 +2798,7 @@ int pci_set_mwi(struct pci_dev *dev)
>  {
>  	return 0;
>  }
> +EXPORT_SYMBOL(pci_set_mwi);
>  
>  int pci_try_set_mwi(struct pci_dev *dev)
>  {
> @@ -2821,6 +2853,7 @@ int pci_try_set_mwi(struct pci_dev *dev)
>  	int rc = pci_set_mwi(dev);
>  	return rc;
>  }
> +EXPORT_SYMBOL(pci_try_set_mwi);
>  
>  /**
>   * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
> @@ -2839,6 +2872,7 @@ pci_clear_mwi(struct pci_dev *dev)
>  		pci_write_config_word(dev, PCI_COMMAND, cmd);
>  	}
>  }
> +EXPORT_SYMBOL(pci_clear_mwi);
>  #endif /* ! PCI_DISABLE_MWI */
>  
>  /**
> @@ -2873,6 +2907,7 @@ pci_intx(struct pci_dev *pdev, int enable)
>  		}
>  	}
>  }
> +EXPORT_SYMBOL_GPL(pci_intx);
>  
>  /**
>   * pci_intx_mask_supported - probe for INTx masking support
> @@ -4038,6 +4073,7 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
>  			bars |= (1 << i);
>  	return bars;
>  }
> +EXPORT_SYMBOL(pci_select_bars);
>  
>  /**
>   * pci_resource_bar - get position of the BAR associated with a resource
> @@ -4389,40 +4425,5 @@ static int __init pci_setup(char *str)
>  }
>  early_param("pci", pci_setup);
>  
> -EXPORT_SYMBOL(pci_reenable_device);
> -EXPORT_SYMBOL(pci_enable_device_io);
> -EXPORT_SYMBOL(pci_enable_device_mem);
> -EXPORT_SYMBOL(pci_enable_device);
> -EXPORT_SYMBOL(pcim_enable_device);
> -EXPORT_SYMBOL(pcim_pin_device);
> -EXPORT_SYMBOL(pci_disable_device);
> -EXPORT_SYMBOL(pci_find_capability);
> -EXPORT_SYMBOL(pci_bus_find_capability);
> -EXPORT_SYMBOL(pci_release_regions);
> -EXPORT_SYMBOL(pci_request_regions);
> -EXPORT_SYMBOL(pci_request_regions_exclusive);
> -EXPORT_SYMBOL(pci_release_region);
> -EXPORT_SYMBOL(pci_request_region);
> -EXPORT_SYMBOL(pci_request_region_exclusive);
> -EXPORT_SYMBOL(pci_release_selected_regions);
> -EXPORT_SYMBOL(pci_request_selected_regions);
> -EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
> -EXPORT_SYMBOL(pci_set_master);
> -EXPORT_SYMBOL(pci_clear_master);
> -EXPORT_SYMBOL(pci_set_mwi);
> -EXPORT_SYMBOL(pci_try_set_mwi);
> -EXPORT_SYMBOL(pci_clear_mwi);
> -EXPORT_SYMBOL_GPL(pci_intx);
>  EXPORT_SYMBOL(pci_assign_resource);

Can you move this to the appropriate file?

> -EXPORT_SYMBOL(pci_find_parent_resource);
> -EXPORT_SYMBOL(pci_select_bars);
>  

This empty line will cause another checkpatch warning, so remove it.

> -EXPORT_SYMBOL(pci_set_power_state);
> -EXPORT_SYMBOL(pci_save_state);
> -EXPORT_SYMBOL(pci_restore_state);
> -EXPORT_SYMBOL(pci_pme_capable);
> -EXPORT_SYMBOL(pci_pme_active);
> -EXPORT_SYMBOL(pci_wake_from_d3);
> -EXPORT_SYMBOL(pci_prepare_to_sleep);
> -EXPORT_SYMBOL(pci_back_from_sleep);
> -EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
